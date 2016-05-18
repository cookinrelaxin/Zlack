defmodule Zlack.Repo do
  use Ecto.Repo, otp_app: :zlack
  use Scrivener, page_size: 10
end
