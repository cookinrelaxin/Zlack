defmodule Zlack.RoomActions do

  alias Zlack.{Room, User, Repo}
  import Ecto.Query, only: [from: 2]
  alias Ecto.Query

  @moduledoc """
    This module defines the real shit: the actions that mutate the state of the application, specifically regarding rooms. Authentication should not be performed here.
  """

  @doc """
    Take a given page number greater than or equal to zero and return at most 10 users per page from the DB.
  """
  def index(%{"page" => page}) do
    page = Room |> Repo.paginate(page: page, page_size: 10)
  end

  def create(%{
    :owner => _owner,
    :title => _room_title,
    :subtitle => _room_subtitle,
    :is_publicly_searchable => _is_publicly_searchable,
    :permission_class => _permission_class
  } = attributes) do
    IO.inspect attributes
    changeset = Room.changeset(%Room{}, attributes)
    res = Repo.insert!(changeset)
    {:ok, res}
  end

end
