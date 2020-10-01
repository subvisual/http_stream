defmodule HTTPStreamTest do
  use HTTPStream.HTTPCase
  doctest HTTPStream

  alias HTTPStream.Adapter

  for adapter <- [Adapter.Mint, Adapter.Poison] do
    Application.put_env(HTTPStream, :adapter, adapter)

    for method <- ~w(get options delete)a do
      describe "[#{adapter}]: #{method}/2" do
        upcased_method = method |> to_string() |> String.upcase()

        test "makes a #{upcased_method} request" do
          %{"method" => method} =
            apply(HTTPStream, unquote(method), ["http://localhost:3000"])
            |> parse_response()

          assert method == unquote(upcased_method)
        end

        test "sets the correct headers" do
          headers = [authorization: "Bearer 123"]

          %{"headers" => headers} =
            apply(HTTPStream, unquote(method), [
              "http://localhost:3000",
              [headers: headers]
            ])
            |> parse_response()

          assert headers["authorization"] == "Bearer 123"
        end

        test "sets the query params" do
          params = [email: "user@example.org"]

          %{"params" => params} =
            apply(HTTPStream, unquote(method), [
              "http://localhost:3000",
              [query: params]
            ])
            |> parse_response()

          assert params["email"] == "user@example.org"
        end
      end
    end

    for method <- ~w(head trace)a do
      describe "#{adapter}: #{method}/2" do
        upcased_method = method |> to_string() |> String.upcase()

        test "makes a #{upcased_method} request" do
          response =
            apply(HTTPStream, unquote(method), ["http://localhost:3000"])
            |> Enum.join("")

          assert response == ""
        end

        test "sets the correct headers" do
          headers = [authorization: "Bearer 123"]

          response =
            apply(HTTPStream, unquote(method), [
              "http://localhost:3000",
              [headers: headers]
            ])
            |> Enum.join("")

          assert response == ""
        end

        test "sets the query params" do
          params = [email: "user@example.org"]

          response =
            apply(HTTPStream, unquote(method), [
              "http://localhost:3000",
              [query: params]
            ])
            |> Enum.join("")

          assert response == ""
        end
      end
    end

    for method <- ~w(post put patch)a do
      describe "#{adapter}: #{method}/2" do
        upcased_method = method |> to_string() |> String.upcase()

        test "makes a #{upcased_method} request" do
          headers = [
            authorization: "Bearer 123",
            "content-type": "application/json"
          ]

          %{"method" => method} =
            apply(HTTPStream, unquote(method), [
              "http://localhost:3000",
              [headers: headers]
            ])
            |> parse_response()

          assert method == unquote(upcased_method)
        end

        test "sets the correct headers" do
          headers = [
            authorization: "Bearer 123",
            "content-type": "application/json"
          ]

          %{"headers" => headers} =
            apply(HTTPStream, unquote(method), [
              "http://localhost:3000",
              [headers: headers]
            ])
            |> parse_response()

          assert headers["authorization"] == "Bearer 123"
        end

        test "sets the params" do
          params = %{email: "user@example.org"}
          headers = ["content-type": "application/json"]

          %{"params" => params} =
            apply(HTTPStream, unquote(method), [
              "http://localhost:3000",
              [headers: headers, params: params]
            ])
            |> parse_response()

          assert params["email"] == "user@example.org"
        end
      end
    end
  end
end
