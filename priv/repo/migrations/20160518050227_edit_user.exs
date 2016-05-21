defmodule Zlack.Repo.Migrations.EditUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      remove :email
      modify :first_name, :text, null: true
      modify :last_name, :text, null: true
      add :username, :text, null: false
    end
  end
end
