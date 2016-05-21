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
          :username => "tjones",
          :password => "pigment watch mouse again",
        },
       invalid_attributes:
        %{
          :first_name => "timothy",
          :last_name => "jones",
          :username => "tjones",
          :password => "password",
        }
   }
   finally do:
    Repo.delete_all(User)

    example "user with valid attributes does not exist" do
      expect Repo.get_by(User, %{:username => shared.valid_attributes.username}) |> to(be_nil)
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
          expect Repo.get_by(User, %{:username => shared.valid_attributes.username}) |> to_not(be_nil)
        end

        let :model, do: Map.from_struct(elem(UserActions.create(shared.valid_attributes), 1))
        it "returns the user's attributes, including their username" do
          attributes = shared.valid_attributes
          username = attributes.username
          expect model |> to(have_key :username)
          expect model |> to(have_value username)
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

      context "given :guest" do

        let :model, do: Map.from_struct(elem(UserActions.create(:guest), 1))
        it "creates a user with a randomly generated username" do
          expect model |> to(have_key :username)
          expect model.username |> to(be_valid_string)
          IO.puts model.username

        end

      end

    end

    xit "temporary users expire in 3 days and are deleted from the database" do
    end

    xit "temporary users are given a jwt for a session to persist in the client" do
    end

    xit "temporary users may become real users if they create a password, change their username, and create 3 private questions and answers" do
    end

    describe ".show" do

      context "given a username" do

        it "returns a user if there is a user with that username" do
          {:ok, _model} = UserActions.create(shared.valid_attributes)
          username = shared.valid_attributes.username
          model = Map.from_struct(UserActions.show(%{"username" => username}))
          expect model |> to(have_key :id)
        end

        it "returns nil if there is no user with that username" do
          {:ok, _model} = UserActions.create(shared.valid_attributes)
          username = shared.valid_attributes.username
          expect UserActions.show(%{"username" => "buku"}) |> to(be_nil)
        end
      end

      context "given an id" do

        it "returns a user if there is a user with that id" do
          {:ok, created_model} = UserActions.create(shared.valid_attributes)
          id = created_model.id
          model = Map.from_struct(UserActions.show(%{"id" => id}))
          expect model |> to(have_key :username)
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
