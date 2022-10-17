defmodule EctoJuno.Application do
  @moduledoc """
    Test application
  """

  use Application

  def start(_type, _args) do
    children = [
      EctoJuno.Repo
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
