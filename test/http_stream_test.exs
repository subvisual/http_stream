defmodule HTTPStreamTest do
  use HTTPStream.HTTPCase
  doctest HTTPStream

  describe "get/2" do
    test "makes a GET request" do
      %{"method" => method} =
        HTTPStream.get("http://localhost:3000")
        |> parse_response()

      assert method == "GET"
    end

    test "sets the correct headers" do
      headers = [authorization: "Bearer 123"]

      %{"headers" => headers} =
        HTTPStream.get("http://localhost:3000", headers: headers)
        |> parse_response()

      assert headers["authorization"] == "Bearer 123"
    end

    test "sets the query params" do
      params = [email: "user@example.org"]

      %{"params" => params} =
        HTTPStream.get("http://localhost:3000", query: params)
        |> parse_response()

      assert params["email"] == "user@example.org"
    end
  end

  describe "post/2" do
    test "makes a POST request" do
      %{"method" => method} =
        HTTPStream.post("http://localhost:3000")
        |> parse_response()

      assert method == "POST"
    end

    test "sets the correct headers" do
      headers = [authorization: "Bearer 123"]

      %{"headers" => headers} =
        HTTPStream.post("http://localhost:3000", headers: headers)
        |> parse_response()

      assert headers["authorization"] == "Bearer 123"
    end

    test "sets the params" do
      params = %{email: "user@example.org"}
      headers = ["content-type": "application/json"]

      %{"params" => params} =
        HTTPStream.post("http://localhost:3000",
          params: params,
          headers: headers
        )
        |> parse_response()

      assert params["email"] == "user@example.org"
    end
  end
end
