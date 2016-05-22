defmodule Zlack.GuestChannel do
  use Zlack.Web, :channel

  alias Zlack.{UserActions}

  def join("guest", _params, socket) do
    {:ok, user} = UserActions.create(:guest)
    {:ok, jwt, _full_claims} = user |> Guardian.encode_and_sign(:token)
    {:ok, %{username: user.username, jwt: jwt, id: user.id}, socket} 
  end

  def handle_in("create_permanent_user" = event,
   %{
     "jwt" => jwt,
     "old_username" => old_username,
     "new_username" => new_username,
     "secret_question_1" => secret_question_1,
     "secret_question_2" => secret_question_2,
     "secret_question_3" => secret_question_3,
     "secret_answer_1" => secret_answer_1,
     "secret_answer_2" => secret_answer_2,
     "secret_answer_3" => secret_answer_3
   } = params, socket) do
    #{:reply, :ok, socket}
    UserActions.update(params)
    push socket, event, %{ok: true}
    {:noreply, socket}
  end

end
