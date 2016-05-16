defmodule Zlack.Room do
  use Zlack.Web, :model

  schema "rooms" do
    field :name, :string
    field :purpose, :string

    belongs_to :user, User
    has_many :messages, Message
    has_many :user_rooms, UserRoom
    has_many :members, through: [:user_rooms, :user]

    timestamps
  end

  @required_fields ~w(name purpose user_id)
  @optional_fields ~w(messages)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
