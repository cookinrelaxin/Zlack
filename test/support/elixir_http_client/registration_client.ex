defmodule Zlack.RegistrationClient do

  @url "localhost:4000/api/v1/registrations"
  @headers [{"accept", "application/json"},
      {"content-type", "application/json"}]

  def create_user(%{
    user: %{
      password_confirmation: _password_confirmation,
      email: _email,
      first_name: _first_name,
      last_name: _last_name,
      password: _password
    }
  } = user_params) do
    HTTPoison.post!(@url, Poison.encode!(user_params), @headers)
  end

  def delete_user(jwt) do
    HTTPoison.request!(:delete, @url, "", @headers ++ [{"authorization", jwt}])
  end

end
