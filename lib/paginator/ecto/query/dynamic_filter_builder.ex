defmodule Paginator.Ecto.Query.DynamicFilterBuilder do
  @moduledoc false

  @dispatch_table %{
    desc: Paginator.Ecto.Query.DescNullsFirst,
    desc_nulls_first: Paginator.Ecto.Query.DescNullsFirst,
    desc_nulls_last: Paginator.Ecto.Query.DescNullsLast,
    asc: Paginator.Ecto.Query.AscNullsLast,
    asc_nulls_last: Paginator.Ecto.Query.AscNullsLast,
    asc_nulls_first: Paginator.Ecto.Query.AscNullsFirst
  }

  @callback build_dynamic_filter(%{
              direction: :after | :before,
              entity_position: integer(),
              column: term(),
              value: term(),
              next_filters: dynamic_expr() | boolean()
            }) :: term()

  @typep dynamic_expr :: %Ecto.Query.DynamicExpr{}

  @type sort_order ::
          :asc
          | :asc_nulls_first
          | :asc_nulls_desc
          | :desc
          | :desc_nulls_first
          | :desc_nulls_last

  @type direction :: :after | :before

  @spec build!(%{
          sort_order: sort_order(),
          direction: direction(),
          entity_position: integer(),
          column: term(),
          value: term(),
          next_filters: dynamic_expr() | boolean()
        }) :: term()
  def build!(input) do
    case Map.fetch(@dispatch_table, input.sort_order) do
      {:ok, module} ->
        module.build_dynamic_filter(input)

      :error ->
        direction = input.direction
        available_sort_orders = @dispatch_table |> Map.keys() |> Enum.join(", ")

        raise("Invalid sorting value :#{direction}, please please use either #{available_sort_orders}")
    end
  end
end
