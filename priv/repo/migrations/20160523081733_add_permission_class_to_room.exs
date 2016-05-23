defmodule Zlack.Repo.Migrations.AddPermissionClassToRoom do
  use Ecto.Migration

  def change do
    alter table(:rooms) do
      add :permission_class, :string, null: false
    end
  end
end
