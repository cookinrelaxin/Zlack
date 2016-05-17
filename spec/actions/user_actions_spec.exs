defmodule Zlack.UserActionsSpec do
  use ESpec, async: false

  alias Zlack.{UserActions, User, Repo}

  @moduledoc """
    This module contains tests for the UserActions module. The functions in UserActions should be called directly -- not over a network. For networked testing, see Zlack.UserControllerTest for HTTP and Zlack.UserChannelTest for WS.
    Tests should act directly with the database for verification.
  """


  context "UserActions" do

    before do:
      {:shared,
       valid_attributes:
        %{
          :first_name => "timothy",
          :last_name => "jones",
          :email => "tjones@gmail.com",
          :password => "pigment watch mouse again",
        },
       invalid_attributes:
        %{
          :first_name => "timothy",
          :last_name => "jones",
          :email => "tjones@gmail.com",
          :password => "password",
        }
   }
   finally do:
    Repo.delete_all(User)

    example "user with valid attributes does not exist" do
      expect Repo.get_by(User, %{:email => shared.valid_attributes.email}) |> to(be_nil)
    end

    describe ".index" do

      context "given a page number" do

        context "given 0" do

          it "returns at most ten users from that page in the database" do

            #UserActions.index(0)

          end

        end

      end

    end

    describe ".create" do

      context "given valid user parameters" do
        it "inserts a new user into the database" do
          {:ok, _model} = UserActions.create(shared.valid_attributes)
          expect Repo.get_by(User, %{:email => shared.valid_attributes.email}) |> to_not(be_nil)
        end

        let :model, do: Map.from_struct(elem(UserActions.create(shared.valid_attributes), 1))
        it "returns the user's attributes, including their email" do
          attributes = shared.valid_attributes
          email = attributes.email
          expect model |> to(have_key :email)
          expect model |> to(have_value email)
        end

        it "returns the user's attributes, including their first name" do
          attributes = shared.valid_attributes
          first_name = attributes.first_name
          expect model |> to(have_key :first_name)
          expect model |> to(have_value first_name)
        end

        it "returns the user's attributes, including their last name" do
          attributes = shared.valid_attributes
          last_name = attributes.last_name
          expect model |> to(have_key :last_name)
          expect model |> to(have_value last_name)
        end

        it "returns the user's attributes, including their password" do
          attributes = shared.valid_attributes
          password = attributes.password
          expect model |> to(have_key :password)
          expect model |> to(have_value password)
        end

        it "returns the user's attributes, including their id" do
          expect model |> to(have_key :id)
          expect is_integer(model.id) |> to(be_true)
        end

        it "returns the time when the user was created" do
          expect model |> to(have_key :inserted_at)
        end

      end

    end

    describe ".show" do

    end

    describe ".update" do

    end

    describe ".delete" do

    end

  end

end
