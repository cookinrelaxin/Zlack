defmodule Zlack.Subscription do
  use Zlack.Web, :model

  alias Zlack.{User, Message, Room}

  @valid_classes ~w(
    read_write
    read
  )

  schema "subscriptions" do
    field :class, :string
    field :accepted_by_room_owner, :boolean
    field :accepted_by_holder, :boolean

    belongs_to :user, User, foreign_key: :holder
    belongs_to :a_room, Room, foreign_key: :room

    timestamps
  end

  @required_fields ~w(class accepted_by_room_owner accepted_by_holder)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> validate_inclusion(:class, @valid_classes)
    |> cast(params, @required_fields, @optional_fields)
  end
end

