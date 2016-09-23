defmodule Docraptorx.HttpClient do
  use HTTPoison.Base

  defp process_url(url) do
    Application.get_env(:docraptorx, :base_url, "https://docraptor.com") <> url
  end

  defp process_request_headers(headers) when is_map(headers) do
    headers
    |> Map.put("Authorization", "Basic " <> auth_key)
    |> Enum.into([])
  end

  defp auth_key do
    Base.encode64("#{Application.get_env(:docraptorx, :api_key)}:")
  end
end
