defmodule Zlack.UserActionsSpec do
  use ESpec, async: false

  alias Zlack.{UserActions}

  @moduledoc """
    This module contains tests for the UserActions module. The functions in UserActions should be called directly -- not over a network. For networked testing, see Zlack.UserControllerTest for HTTP and Zlack.UserChannelTest for WS.
  """

  context "UserActions" do

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
        end

        it "returns the user's attributes, including their id" do
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

  # test "index" do
  # end

  # test "create" do
  # end

  # test "show" do
  # end

  # test "update" do
  # end

  # test "delete" do
  # end

end
