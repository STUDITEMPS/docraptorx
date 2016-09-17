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
end
