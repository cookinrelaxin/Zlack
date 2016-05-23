defmodule Zlack.Repo.Migrations.UpdateRoomTable do
  use Ecto.Migration

  def change do
    rename table(:rooms), :name, to: :title
    rename table(:rooms), :purpose, to: :subtitle
    rename table(:rooms), :user_id, to: :owner
  end
end
