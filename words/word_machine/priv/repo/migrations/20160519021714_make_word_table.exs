defmodule WordMachine.Repo.Migrations.MakeWordTable do
  use Ecto.Migration

  def change do
    create table(:nouns) do
      add :text, :string, null: false
    end

    create table(:adjectives) do
      add :text, :string, null: false
    end

    create table(:adverbs) do
      add :text, :string, null: false
    end
  end
end
