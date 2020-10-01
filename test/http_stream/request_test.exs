defmodule HTTPStream.RequestTest do
  use ExUnit.Case

  alias HTTPStream.Request

  describe "new/3" do
    test "generates the correct structure" do
      url = "http://localhost:4000"

      assert %Request{
               scheme: :http,
               host: "localhost",
               port: 4000,
               path: "/",
               method: "GET",
               headers: [],
               body: ""
             } == Request.new("GET", url)
    end

    test "correctly parses query params" do
      url = "http://localhost:4000"
      query = [id: 1, filter: true]

      assert %Request{
               scheme: :http,
               host: "localhost",
               port: 4000,
               path: "/?id=1&filter=true",
               method: "GET",
               headers: [],
               body: ""
             } == Request.new("GET", url, body: query)
    end

    test "correctly parses body params" do
      url = "http://localhost:4000"
      params = %{id: 1, filter: true}

      assert %Request{
               scheme: :http,
               host: "localhost",
               port: 4000,
               path: "/",
               method: "POST",
               headers: [],
               body: params
             } == Request.new("POST", url, body: params)
    end
  end

  describe "url_for/1" do
    test "generates the correct URL" do
      url = "http://localhost:4000"
      query = [id: 1, filter: true]
      request = Request.new("GET", url, body: query)

      expected_url = "http://localhost:4000/?id=1&filter=true"
      assert expected_url == Request.url_for(request)
    end
  end
end
