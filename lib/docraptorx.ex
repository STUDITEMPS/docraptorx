defmodule Docraptorx do
  alias Docraptorx.HttpClient

  def create!(opts \\ %{}) do
    body = JSX.encode!(opts)
    headers = %{"Content-type": "application/json"}
    response = HttpClient.post!("/docs", body, headers)
    IO.inspect(response)
    if response.status_code === 200 do
      {:ok, response.body}
    else
      {:error, response.body}
    end
  end

  def status!(status_id) do
    response = HttpClient.get!("/status/#{status_id}", %{})
    if response.status_code === 200 do
      {:ok, response.body}
    else
      {:error, response.body}
    end
  end

  def configure(api_key, base_url \\ "https://docraptor.com") do
    Application.put_env(:docraptorx, :api_key, api_key)
    Application.put_env(:docraptorx, :base_url, base_url)
  end
end
