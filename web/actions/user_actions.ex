defmodule Zlack.UserActions do
  @moduledoc """
    This module defines the real shit: the actions that mutate the state of the application, specifically regarding users. Authentication should not be performed here??? idk
  """

  @doc """

  """
  def index(%{"page" => page}) do
    IO.inspect page
  end

  @doc """

  """
  def create(_params) do
    nil
  end

  @doc """

  """
  def show(%{"id" => id}) do
    nil
  end

  @doc """

  """
  def update(%{"id" => id}) do
    nil
  end

  @doc """

  """
  def delete(%{"id" => id}) do
    nil
  end


end
