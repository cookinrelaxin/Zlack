defmodule Zlack.Room do
  use Zlack.Web, :model

  alias Zlack.{User, Message, Subscription}

  @valid_permissions ~w(
    may_request_read_write_subscription
    may_request_read_subscription
    auto_grant_read_write_subscription
    auto_grant_read_subscription
    invite_only
  )

  schema "rooms" do
    field :title, :string
    field :subtitle, :string
    field :permission_class, :string

    belongs_to :user, User, foreign_key: :owner
    #has_many :messages, Message
    has_many :subscriptions, Subscription, foreign_key: :room

    timestamps
  end

  @required_fields ~w(title owner permission_class)
  @optional_fields ~w(subtitle)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    #|> validate_inclusion(:permission_class, @valid_permissions)
    |> cast(params, @required_fields, @optional_fields)
  end
end
