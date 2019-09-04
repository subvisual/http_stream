defmodule HTTPStream do
  def get(url) do
    Stream.resource(
      fn -> start_connection(url) end,
      &parse_response_chunks/1,
      &close_connection/1
    )
    |> Stream.filter(&data_message?/1)
    |> Stream.map(fn {:data, _ref, chunk} -> chunk end)
  end

  defp start_connection(url) do
    with uri <- URI.parse(url),
         {:ok, conn} <- Mint.HTTP.connect(String.to_atom(uri.scheme), uri.host, uri.port),
         {:ok, conn, ref} <- Mint.HTTP.request(conn, "GET", uri.path, [], "") do
      {conn, ref, :continue}
    end
  end

  defp parse_response_chunks({conn, ref, :halt}), do: {:halt, {conn, ref}}

  defp parse_response_chunks({conn, ref, :continue}) do
    receive do
      message ->
        case Mint.HTTP.stream(conn, message) do
          :unknown -> handle_unknown_message(conn, ref)
          {:ok, conn, responses} -> handle_responses(conn, ref, responses)
        end
    end
  end

  defp close_connection({conn, _ref}) do
    Mint.HTTP.close(conn)
  end

  defp handle_responses(conn, ref, responses) do
    if Enum.any?(responses, &done_message?/1) do
      {responses, {conn, ref, :halt}}
    else
      {responses, {conn, ref, :continue}}
    end
  end

  defp handle_unknown_message(conn, ref), do: {[], {conn, ref, :continue}}

  defp message_type(message) when is_tuple(message), do: elem(message, 0)
  defp data_message?(message), do: message_type(message) == :data
  defp done_message?(message), do: message_type(message) == :done
end