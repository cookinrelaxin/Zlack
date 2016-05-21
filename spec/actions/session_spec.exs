defmodule Zlack.SessionSpec do
  use ESpec, async: false

  alias Zlack.{}

  @moduledoc """
    This module contains tests for the SessionActions module. The functions in SessionActions should be called directly -- not over a network. For networked testing, see Zlack.SessionControllerTest for HTTP and Zlack.UserChannelTest for WS.
    Tests should act directly with the database for verification.
  """

  context "SessionActions" do
    context ".create" do
      # context "given :guest" do
      #   it "creates a new user" do
      #   end
      # end
    end
  end

end
