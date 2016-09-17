defmodule Docraptorx do
  alias Docraptorx.HttpClient

  def configure(api_key, base_url \\ "https://docraptor.com") do
    Application.put_env(:docraptorx, :api_key, api_key)
    Application.put_env(:docraptorx, :base_url, base_url)
  end
end
