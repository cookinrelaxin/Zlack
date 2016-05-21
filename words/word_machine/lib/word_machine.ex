defmodule WordMachine.Repo do
  use Ecto.Repo, otp_app: :word_machine

end

defmodule WordMachine.Noun do
  use Ecto.Schema

  schema "nouns" do
    field :text, :string
  end

end

defmodule WordMachine.Adjective do
  use Ecto.Schema

  schema "adjectives" do
    field :text, :string
  end

end

defmodule WordMachine.Adverb do
  use Ecto.Schema

  schema "adverbs" do
    field :text, :string
  end

end

defmodule WordMachine.Runner do

  alias WordMachine.{Repo, Noun, Adjective, Adverb}

  def start_link do
    IO.puts "woohoo!"

    import_adverbs_to_db
    System.halt(0)
  end

  def remove_proper_nouns() do
    orignal_noun_path = "../original_words/nouns/91K nouns.txt"
    processed_noun_path = "../processed_words/nouns.txt"
    File.rm!(processed_noun_path)
    File.touch!(processed_noun_path)

    stream = File.stream!(orignal_noun_path, [], :line)

    stream
    |> Stream.filter(fn(word) -> Regex.match?(~r/^[a-z]/, word) end)
    |> Stream.into(File.stream!(processed_noun_path))
    |> Stream.run
  end

  def remove_proper_adjectives() do
    orignal_adjective_path = "../original_words/adjectives/28K adjectives.txt"
    processed_adjective_path = "../processed_words/adjectives.txt"
    File.rm!(processed_adjective_path)
    File.touch!(processed_adjective_path)

    stream = File.stream!(orignal_adjective_path, [], :line)

    stream
    |> Stream.filter(fn(word) -> Regex.match?(~r/^[a-z]/, word) end)
    |> Stream.into(File.stream!(processed_adjective_path))
    |> Stream.run
  end

  def remove_proper_adverbs() do
    orignal_adverbs_path = "../original_words/adverbs/6K adverbs.txt"
    processed_adverbs_path = "../processed_words/adverbs.txt"
    File.rm!(processed_adverbs_path)
    File.touch!(processed_adverbs_path)

    stream = File.stream!(orignal_adverbs_path, [], :line)

    stream
    |> Stream.filter(fn(word) -> Regex.match?(~r/^[a-z]/, word) end)
    |> Stream.into(File.stream!(processed_adverbs_path))
    |> Stream.run
  end

  def import_nouns_to_db do
    Repo.delete_all(Noun)
    processed_noun_path = "../processed_words/nouns.txt"
    stream = File.stream!(processed_noun_path, [], :line)

    stream
    |> Stream.each(fn(word) -> 
     cleaned = word
     |> String.strip
     |> String.replace_suffix("\n", "")
     Repo.insert!(%Noun{text: cleaned})
    end)
    |> Stream.run
  end

  def import_adjectives_to_db do
    Repo.delete_all(Adjective)
    processed_adjective_path = "../processed_words/adjectives.txt"
    stream = File.stream!(processed_adjective_path, [], :line)

    stream
    |> Stream.each(fn(word) -> 
     cleaned = word
     |> String.strip
     |> String.replace_suffix("\n", "")
     Repo.insert!(%Adjective{text: cleaned})
    end)
    |> Stream.run
  end

  def import_adverbs_to_db do
    Repo.delete_all(Adverb)
    processed_adverb_path = "../processed_words/adverbs.txt"
    stream = File.stream!(processed_adverb_path, [], :line)

    stream
    |> Stream.each(fn(word) -> 
     cleaned = word
     |> String.strip
     |> String.replace_suffix("\n", "")
     Repo.insert!(%Adverb{text: cleaned})
    end)
    |> Stream.run
  end

end

defmodule WordMachine do
  use Application


  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(WordMachine.Repo, []),
      worker(WordMachine.Runner, [])
    ]

    opts = [strategy: :one_for_one, name: WordMachine.Supervisor]
    Supervisor.start_link(children, opts)
  end

end

#WordMachine.remove_proper_nouns()
#WordMachine.remove_proper_adjectives()
#WordMachine.remove_proper_adverbs()
#
#WordMachine.import_nouns_to_db
