defmodule Docraptorx do
  @moduledoc """
  Docraptor API client for Elixir.

  ```elixir
  Docraptorx.configure("your api key")

  Docraptorx.create!(document_type: "pdf",
                     document_content: "<html><body>Hello World!</body></html>"
                     name: "hello.pdf",
                     async: true)
  #=> %{"status_id": "a4096ef2-fde6-48f5-bbeb-ce2ad6873098"}

  Docraptorx.status!("a4096ef2-fde6-48f5-bbeb-ce2ad6873098")
  #=> %{"status" => "completed", "download_id" => "...", "download_url" => "...", "number_of_pages" => 1}
  ```

  For detailed information about the options, see [official documentation](https://docraptor.com/documentation).
  """

  alias Docraptorx.HttpClient

  @doc """
  Create a document with specified options.
  """
  def create!(opts \\ %{}) do
    body = JSX.encode!(opts)
    headers = %{"Content-type": "application/json"}
    HttpClient.post!("/docs", body, headers)
    |> parse_response
  end

  @doc """
  Fetch the status of the document job specified by status_id.
  """
  def status!(status_id) do
    HttpClient.get!("/status/#{status_id}", %{})
    |> parse_response
  end

  @doc """
  Get a list of created documents, ordered by date of creation (most recent first).
  """
  def docs!(params \\ %{}) do
    HttpClient.get!("/docs.json", %{}, params: params)
    |> parse_response
  end

  @doc """
  Get a list of attempted document creations, ordered by date of creation (most recent first).
  """
  def logs!(params \\ %{}) do
    HttpClient.get!("/doc_logs.json", %{}, params: params)
    |> parse_response
  end

  def parse_response(response) do
    if response.status_code == 200 do
      case JSX.decode(response.body) do
        {:ok, body} -> body
        {:error, _} -> response.body
      end
    else
      %{"error" => parse_error(response.body)}
    end
  end

  defp parse_error(body) do
    body
    |> Exml.parse
    |> Exml.get("//error/text()")
  end

  def configure(api_key, base_url \\ "https://docraptor.com") do
    Application.put_env(:docraptorx, :api_key, api_key)
    Application.put_env(:docraptorx, :base_url, base_url)
  end
end
