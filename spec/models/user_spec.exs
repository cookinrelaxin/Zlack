defmodule Zlack.UserSpec do
  use ESpec, async: false
  alias Zlack.{User, Repo}

  @moduledoc """
    This module contains tests for the Zlack.User module. Tests should very thouroughly specify scenarios in which user attributes are valid and invalid.
  """

  before do:
    {:shared, valid_attributes: %{
      :first_name => "timothy",
      :last_name => "jones",
      :email => "tjones@gmail.com",
      :password => "howl once again",
    }
  }
  describe "User" do

    example "valid attributes" do
      changeset = User.changeset(%User{}, shared.valid_attributes)
      expect changeset.valid? |> to(be_true)
    end

    example "invalid attributes" do
      changeset = User.changeset(
        %User{},
        Map.put(shared.valid_attributes, :email, "tjonesgmail.com")

      )
      expect changeset.valid? |> to(be_false)
    end

    context "first name" do
      # it "must be a string" do
      #   changeset = User.changeset(%User{}, %{
      #     :first_name => "timothy",
      #     :last_name => "timothy",
      #   })
      # end

    end

  end

end

