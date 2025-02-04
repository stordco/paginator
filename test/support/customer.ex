defmodule Paginator.Customer do
  use Ecto.Schema

  import Ecto.Query

  schema "customers" do
    field(:name, :string)
    field(:active, :boolean)
    field(:internal_uuid, :binary_id)
    field(:rank_value, :float, virtual: true)

    has_many(:payments, Paginator.Payment)
    has_one(:address, Paginator.Address)

    timestamps()
  end

  def active(query) do
    where(query, [c], c.active == true)
  end
end
