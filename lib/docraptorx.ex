defmodule Docraptorx do
  @moduledoc """
  Docraptor API client for Elixir.

  ```elixir
  Docraptorx.configure("your api key")

  Docraptorx.create!(document_type: "pdf",
                     document_content: "<html><body>Hello World!</body></html>",
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
    body = Jason.encode!(opts)
    headers = %{"Content-Type": "application/json"}
    options = [timeout: 60_000, recv_timeout: 60_000]

    HttpClient.post!("/docs", body, headers, options)
    |> parse_response
  end

  @doc """
  Create a document with specified options and returns pdf_binary and number of document pages
  """
  def create(opts \\ %{}) do
    body = Jason.encode!(opts)
    headers = %{"Content-Type": "application/json"}

    HttpClient.post!("/docs", body, headers)
    |> parse_response(true)
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

  def parse_response(response) when response.status_code == 200 do
    case Jason.decode(response.body) do
        {:ok, body} -> body
        {:error, _} -> response.body
      end
  end

    def parse_response(response, _include_number_of_pages)
      when response.status_code == 200 do
      case Jason.decode(response.body) do
        {:ok, body} -> %{pdf_binary: body, number_of_pages: extract_numbert_of_pages(response.headers)}
        {:error, _} -> %{pdf_binary: response.body, number_of_pages: extract_numbert_of_pages(response.headers)}
      end
    end

  def parse_response(response),
    do: %{"error" => parse_error(response.body)}

  defp parse_error(body) do
    body
    |> Exml.parse()
    |> Exml.get("//error/text()")
  end

  defp extract_numbert_of_pages(headers) do
    %{"X-DocRaptor-Num-Pages" => value} = headers |> Enum.into(%{})
    value |> String.to_integer
  end


  def configure(api_key, base_url \\ nil) do
    Application.put_env(:docraptorx, :api_key, api_key)

    if String.valid?(base_url) && String.strip(base_url) != "" do
      Application.put_env(:docraptorx, :base_url, base_url)
    end
  end
end
