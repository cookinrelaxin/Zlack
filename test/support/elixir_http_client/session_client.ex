defmodule Zlack.SessionClient do

  @url "localhost:4000/api/v1/sessions"
  @headers [{"accept", "application/json"},
      {"content-type", "application/json"}]

  def create_session(%{
    session: %{
      email: _email,
      password: _password
    }
  } = session_params) do
    HTTPoison.post!(@url, Poison.encode!(session_params), @headers)
  end

  def delete_session(jwt) do
    HTTPoison.request!(:delete, @url, "", @headers ++ [{"authorization", jwt}])
  end

end
