defmodule Zlack.UserRoom do
  use Zlack.Web, :model

  schema "user_rooms" do
    belongs_to :user, Zlack.User
    belongs_to :room, Zlack.Room

    timestamps
  end

  @required_fields ~w(user_id room_id)
  @optional_fields ~w()

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
