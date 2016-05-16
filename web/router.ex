defmodule Zlack.Router do
  use Zlack.Web, :router

  @doc """
  This module defines the HTTP REST API endpoints for the Zlack application. This API should only be used for non-real-time requests, where we do not care about users immediately seeing updated data.
  Real-time requests belong in the WS API instead.
  """

  pipeline :api do
    plug :accepts, ["json"]
    plug Guardian.Plug.VerifyHeader
    plug Guardian.Plug.LoadResource
  end

  scope "/api", Zlack do
    pipe_through :api

    scope "/v1" do
      post "/registrations", RegistrationController, :create
      delete "/registrations", RegistrationController, :delete

      post "/sessions", SessionController, :create
      delete "/sessions", SessionController, :delete

      get "/current_user", CurrentUserController, :show

      #subscriptions
      resources "/subscriptions", SubscriptionController, except: [:new, :edit]

      #messages
      resources "/messages", MessagesController, except: [:new, :edit]

      #rooms
      resources "/rooms", RoomController, except: [:new, :edit] do

        #the subscriptions for a given room
        resources "/subscriptions", SubscriptionController, except: [:new, :edit]

        #the messages posted in a given room
        resources "/messages", MessagesController, except: [:new, :edit]
      end

      #users
      resources "/users", UserController, except: [:new, :edit] do

        #the subscriptions for a given user
        resources "/subscriptions", SubscriptionController, except: [:new, :edit]
        
        #the messages posted in a given room
        resources "/messages", MessagesController, except: [:new, :edit]

        #the owned rooms for a given user
        resources "/rooms", RoomController, except: [:new, :edit] do

          #the subscriptions for a given room
          resources "/subscriptions", SubscriptionController, except: [:new, :edit]

          #the messages posted in a given room
          resources "/messages", MessagesController, except: [:new, :edit]
        end
      end

    end
  end

end
