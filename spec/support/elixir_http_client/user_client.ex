defmodule Zlack.UserHTTPClient do

  @moduledoc """
    This module is simply a wrapper for HTTP requests to the user endpoints of the Zlack API. If anything weird is going on in these functions, something is wrong.

    Each function takes a JSON Web Token string to authenticate the requests. You can obtain one from Zlack.RegistrationHTTPClient.
  """

  @url "localhost:4000/api/v1/users"
  @headers [{"accept", "application/json"},
      {"content-type", "application/json"}]


  @doc """
  Send HTTP GET request for /api/v1/users?page=page
  """
  def index(params, jwt) do
    HTTPoison.get!(@url, Poison.encode!(params), @headers ++ [{"authorization", jwt}])
  end

  @doc """
  Send HTTP POST request for /api/v1/users
  """
  def create(params, jwt) do
    HTTPoison.post!(@url, Poison.encode!(params), @headers ++ [{"authorization", jwt}])
  end

  @doc """
  Send HTTP GET request for /api/v1/users/:id
  """
  def show(params, jwt) do
    HTTPoison.get!(@url, Poison.encode!(params), @headers ++ [{"authorization", jwt}])
  end

  @doc """
  Send HTTP PATCH or PUT request for /api/v1/users/:id.
  "Or", you say? Yeah, it doesn't matter.
  """
  def update(params, jwt) do
    HTTPoison.put!(@url, Poison.encode!(params), @headers ++ [{"authorization", jwt}])
  end

  @doc """
  Send HTTP DELETE request for /api/v1/users/:id
  """
  def delete(params, jwt) do
    HTTPoison.delete!(@url, Poison.encode!(params), @headers ++ [{"authorization", jwt}])
  end

end
