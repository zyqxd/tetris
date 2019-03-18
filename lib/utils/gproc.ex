defmodule Utils.Gproc do
  @moduledoc """
  Elixir :gproc wrapper module.
  """

  @doc "Lookup by term, for local processes"
  def lookup({type, scope, term}) do
    case :gproc.where({type, scope, term}) do
      :undefined -> {:error, :undefined}
      pid -> {:ok, pid}
    end
  end

  @doc "Look up by pid, for local processes"
  def term(pid) do
    case pid |> :gproc.info() |> Keyword.get(:gproc) do
      [{{:n, :l, term}, _}] -> {:ok, term}
      [{{_type, _scope, _term}, _}] -> {:error, :undefined}
      _ -> {:error, :unexpected}
    end
  end
end
