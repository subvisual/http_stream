defmodule HTTPStreamTest do
  use HTTPStream.HTTPCase
  doctest HTTPStream

  describe "get/2" do
    test "sets the correct headers" do
      headers = [{"authorization", "Bearer 123"}]

      %{"headers" => headers} =
        HTTPStream.get("http://localhost:3000", headers: headers)
        |> parse_response()

      assert headers["authorization"] == "Bearer 123"
    end

    test "sets the query params" do
      params = [{"email", "user@example.org"}]

      %{"params" => params} =
        HTTPStream.get("http://localhost:3000", query: params)
        |> parse_response()

      assert params["email"] == "user@example.org"
    end
  end
end
