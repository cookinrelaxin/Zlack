defmodule Zlack.Repo.Migrations.AddGuestField do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :is_guest, :boolean, null: false
    end
  end
end
