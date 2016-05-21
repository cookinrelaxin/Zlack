defmodule Zlack.Factory do
  use ExMachina.Ecto, repo: Zlack.Repo

  def factory(:user) do
    #IO.puts "factory(:user) does no validation. be warned."
    %Zlack.User{
      first_name: "Bobby",
      last_name: "Timmons",
      username: "btimmons",
      password: "tatum waller johnson smith",
      encrypted_password: "aasdf07896asdyfuhlasdjkl4",
    }
  end

end
