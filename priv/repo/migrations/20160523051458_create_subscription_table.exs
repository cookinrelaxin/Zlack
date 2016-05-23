defmodule Zlack.Repo.Migrations.CreateSubscriptionTable do
  use Ecto.Migration

  def change do
    create table(:subscriptions) do
      add :holder, references(:users), null: false
      add :room, references(:rooms), null: false
      add :class, :string, null: false

      add :accepted_by_room_owner, :boolean, null: false, default: false
      add :accepted_by_holder, :boolean, null: false, default: false

      timestamps
    end

  end
end
