defmodule HTTPStream.Adapter do
  @moduledoc """
  Adapter behaviour for HTTPStream compatible clients.

  An adapter must implement the following callbacks:

  * `request/1` - Receives an `HTTPStream.Request.t()` and initiates the HTTP
  connection to the endpoint.
  * `parse_chunks/1` - Receives values of any type returned by `request/1` and
  reads a chunk of data from the connection.
  * `close/1` - Called when the final value from `parse_chunks/1` is read.
  Should close the connection.

  Currently supported adapters: `HTTPStream.Adapter.Mint`
  """

  alias HTTPStream.Request

  @callback request(Request.t()) :: any()
  @callback parse_chunks(any()) :: any()
  @callback close(any()) :: :ok | {:error, term()}
end
