defmodule Zlack.UserSpec do
  use ESpec, async: false
  alias Zlack.{User}

  @moduledoc """
    This module contains tests for the Zlack.User module. Tests should very thouroughly specify scenarios in which user attributes are valid and invalid. Tests should not interact with the database here. Instead, work with changesets. We do little validation on names because there are too many edge cases. Ecto supposedly protects against SQL injection, but that must too be tested.
  """

  before do:
    {:shared, valid_attributes: %{
      :first_name => "timothy",
      :last_name => "jones",
      :username => "tjones",
      :password => "pigment watch mouse again",
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
        Map.put(shared.valid_attributes, :username, "")
      )
      expect changeset.valid? |> to(be_false)
    end

    context "first name" do
      it "must be a string" do
        changeset = User.changeset(
          %User{},
          Map.put(shared.valid_attributes, :first_name, 2345)
        )
        expect changeset.valid? |> to(be_false)
      end

    end

    context "last name" do
      it "must be a string" do
        changeset = User.changeset(
          %User{},
          Map.put(shared.valid_attributes, :last_name, [:bad])
        )
        expect changeset.valid? |> to(be_false)
      end

    end

    context "password" do
      it "must be a string" do
        changeset = User.changeset(
          %User{},
          Map.put(shared.valid_attributes, :password, 8558)
        )
        expect changeset.valid? |> to(be_false)
      end

      describe "must contain four 5+ character words separated by spaces (xkcd method)" do
        context ~S("correct horse battery staple") do
          it "is valid" do
            changeset = User.changeset(
              %User{},
              Map.put(shared.valid_attributes, :password, "correct horse battery staple")
            )
            expect changeset.valid? |> to(be_true)
          end
        end

        context ~S("correct horse battery") do
          it "is invalid (too few words)" do
            changeset = User.changeset(
              %User{},
              Map.put(shared.valid_attributes, :password, "correct horse battery")
            )
            expect changeset.valid? |> to(be_false)
          end
        end

        context ~S("correct bear battery staple") do
          it "is invalid (\"bear\" is too short)" do
            changeset = User.changeset(
              %User{},
              Map.put(shared.valid_attributes, :password, "correct bear battery staple")
            )
            expect changeset.valid? |> to(be_false)
          end
        end
      end

    end

  end

end
