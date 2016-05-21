use Mix.Config

config :word_machine, WordMachine.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "zlack_dev",
  username: "johnfeldcamp",
  password: "raydhadman",
  hostname: "localhost"

