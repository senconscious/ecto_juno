defmodule EctoJuno.Helpers.SortingTemplateParams do
  @moduledoc """
    Module for manipulating sorting template params
  """

  use Ecto.Schema

  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :sort_by, :string
    field :sort_direction, :string
  end

  def get_sort_by(attrs) do
    %__MODULE__{}
    |> cast(attrs, [:sort_by])
    |> get_change(:sort_by)
  end

  def patch_sort_by(attrs, sort_by) do
    %__MODULE__{}
    |> cast(attrs, [:sort_by, :sort_direction])
    |> put_change(:sort_by, sort_by)
    |> then(fn %{changes: changes} -> changes end)
  end
end
