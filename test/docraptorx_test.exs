defmodule DocraptorxTest do
  use ExUnit.Case
  doctest Docraptorx

  test "parse_response should retrieve error message" do
    response = %HTTPoison.Response{
      status_code: 422,
      body: """
      <?xml version="1.0" encoding="UTF-8"?>
      <errors>
        <error>Name can't be blank</error>
      </errors>
      """
    }
    expected = %{"error" => "Name can't be blank"}
    assert Docraptorx.parse_response(response) == expected
  end

  test "parse_response should retrieve status_id from async response" do
    response = %HTTPoison.Response{
      status_code: 200,
      body: """
      {"status_id": "a status id"}
      """
    }
    expected = %{"status_id" => "a status id"}
    assert Docraptorx.parse_response(response) == expected
  end

  test "parse_response should return raw response body for non-JSON successful response" do
    response = %HTTPoison.Response{
      status_code: 200,
      body: """
      %PDF-1.7
      some pdf content
      %%EOF
      """
    }
    expected = response.body
    assert Docraptorx.parse_response(response) == expected
  end

  test "configure should not set blank base_url" do
    Docraptorx.configure("api key", " ")
    assert Application.fetch_env(:docraptorx, :base_url) == :error
  end

  test "configure should not set non-string base_url" do
    Docraptorx.configure("api key", 123)
    assert Application.fetch_env(:docraptorx, :base_url) == :error
  end

  test "configure should set application env" do
    Docraptorx.configure("api key", "https://example.com")
    assert Application.get_env(:docraptorx, :api_key) == "api key"
    assert Application.get_env(:docraptorx, :base_url) == "https://example.com"
  end
end
