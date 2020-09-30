defmodule HTTPStream.Integration.LargeFileTest do
  use HTTPStream.HTTPCase

  alias HTTPStream.HTTPServer.RespondWithFixture

  @output_path "out.tif"

  describe "large file download" do
    @describetag respond_with: RespondWithFixture

    test "streaming to another process" do
      pid = self()

      spawn fn ->
        HTTPStream.get("http://localhost:3000")
        |> Stream.map(fn chunk ->
          send pid, {:data, chunk}
        end)
        |> Stream.run()
      end

      assert_receive {:data, _chunk}
      assert_receive {:data, _chunk}
    end

    test "streaming to the file system" do
      on_exit(fn ->
        File.rm!(@output_path)
      end)

      spawn fn ->
        HTTPStream.get("http://localhost:3000")
        |> Stream.into(File.stream!(@output_path))
        |> Stream.run()
      end

      # Ugly but needed to wait for the file to be created
      Process.sleep(100)

      {:ok, %{size: size_1}} = File.stat(@output_path)
      Process.sleep(100)
      {:ok, %{size: size_2}} = File.stat(@output_path)
      Process.sleep(100)
      {:ok, %{size: size_3}} = File.stat(@output_path)

      assert size_2 > size_1
      assert size_3 > size_2
    end
  end
end
