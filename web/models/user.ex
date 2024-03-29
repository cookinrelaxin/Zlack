defmodule Zlack.User do
  use Zlack.Web, :model

  alias Zlack.{Room, Subscription}

  @derive {Poison.Encoder, only: [:id, :first_name, :last_name, :email]}

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :username, :string
    field :is_guest, :boolean
    field :encrypted_password, :string
    field :password, :string, virtual: true

    has_many :rooms, Room, foreign_key: :owner
    has_many :subscriptions, Subscription, foreign_key: :holder

    timestamps
  end

  @required_fields ~w(password username is_guest)
  @optional_fields ~w(first_name last_name encrypted_password)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_format(:password, ~r/\w{5,}\s\w{5,}\s\w{5,}\s\w{5,}/)
    |> validate_confirmation(:password, message: "Password does not match")
    |> validate_format(:username, ~r/.+/)
    |> unique_constraint(:username, message: "Email already taken")
    |> generate_encrypted_password
  end

  defp generate_encrypted_password(current_changeset) do
    case current_changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(current_changeset, :encrypted_password, Comeonin.Bcrypt.hashpwsalt(password))
      _ ->
        current_changeset
    end
  end
end
