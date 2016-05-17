ESpec.configure fn(config) ->
  config.before fn ->
    Zlack.Repo.delete_all(Zlack.User)
  end

  config.finally fn(_shared) ->
    :ok
  end
end
