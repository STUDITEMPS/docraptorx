defmodule Docraptorx do
  alias Docraptorx.HttpClient

  def create!(opts \\ %{}) do
    body = JSX.encode!(opts)
    headers = %{"Content-type": "application/json"}
    HttpClient.post!("/docs", body, headers)
    |> parse_response
  end

  def status!(status_id) do
    HttpClient.get!("/status/#{status_id}", %{})
    |> parse_response
  end

  defp parse_response(response) do
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
