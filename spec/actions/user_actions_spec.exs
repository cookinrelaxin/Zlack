defmodule Zlack.UserActionsSpec do
  use ESpec, async: false

  alias Zlack.{UserActions, User, Repo, Factory}

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

        context "given page = 1" do

          it "returns 1 user from a database of 1 user" do
            Factory.create(:user)
            index_results = UserActions.index(%{"page" => 1})

            expect index_results.page_number |> to(eq 1)
            expect index_results.page_size |> to(eq 10)
            expect index_results.total_pages |> to(eq 1)
            expect index_results.total_entries |> to(eq 1)

            expect index_results.entries |> to(have_length 1)
          end

          it "returns 10 users from a database of 10 users" do
            Factory.create_list(10,:user)

            index_results = UserActions.index(%{"page" => 1})

            expect index_results.page_number |> to(eq 1)
            expect index_results.page_size |> to(eq 10)
            expect index_results.total_pages |> to(eq 1)
            expect index_results.total_entries |> to(eq 10)

            expect index_results.entries |> to(have_length 10)
          end

          it "returns 10 users from a database of 15 users" do
            Factory.create_list(15,:user)

            index_results = UserActions.index(%{"page" => 1})

            expect index_results.page_number |> to(eq 1)
            expect index_results.page_size |> to(eq 10)
            expect index_results.total_pages |> to(eq 2)
            expect index_results.total_entries |> to(eq 15)

            expect index_results.entries |> to(have_length 10)

          end

        end

        context "given page = 2" do

          it "returns 5 users from a database of 15 users" do
              Factory.create_list(15,:user)

              index_results = UserActions.index(%{"page" => 2})

              expect index_results.page_number |> to(eq 2)
              expect index_results.page_size |> to(eq 10)
              expect index_results.total_pages |> to(eq 2)
              expect index_results.total_entries |> to(eq 15)

              expect index_results.entries |> to(have_length 5)

          end

        end

      end

      context "given user attributes" do
          context "given a first name" do
          end

          context "given a last name" do
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

      context "given an email address" do

        it "returns a user if there is a user with that email address" do
          {:ok, _model} = UserActions.create(shared.valid_attributes)
          email = shared.valid_attributes.email
          model = Map.from_struct(UserActions.show(%{"email" => email}))
          expect model |> to(have_key :id)
        end

        it "returns nil if there is no user with that email address" do
          {:ok, _model} = UserActions.create(shared.valid_attributes)
          email = shared.valid_attributes.email
          expect UserActions.show(%{"email" => "btimmons@gmail.com"}) |> to(be_nil)
        end
      end

      context "given an id" do

        it "returns a user if there is a user with that id" do
          {:ok, created_model} = UserActions.create(shared.valid_attributes)
          id = created_model.id
          model = Map.from_struct(UserActions.show(%{"id" => id}))
          expect model |> to(have_key :email)
        end

        it "returns nil if there is no user with that id" do
          {:ok, created_model} = UserActions.create(shared.valid_attributes)
          id = created_model.id
          expect UserActions.show(%{"id" => 412341234}) |> to(be_nil)
        end
      end

    end

    describe ".update" do

    end

    describe ".delete" do

    end

  end

end
