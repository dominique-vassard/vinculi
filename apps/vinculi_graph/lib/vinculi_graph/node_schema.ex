defmodule VinculiGraph.NodeSchema do
  @moduledoc """
    Behaviour for node schemas
  """

  @doc """
    Returns the node name
  """
  @callback get_name_fields() :: List.t

  @doc """
    Provides the schema changeset
  """
  @callback changeset(Ecto.Schema.t | Enum.t, Keyword.t) :: Enum.t

  defmacro __using__(_) do
    quote([]) do
      @behaviour VinculiGraph.NodeSchema
      import Ecto.Changeset

      @doc """
        Default changeset
      """
      def changeset(struct, params \\ %{}) do
        struct
        |> cast(params, get_non_id_fields())
      end

      @doc """
        Default name getter
      """
      def get_name_fields() do
         [:name]
      end

      @doc """
        Retrieve non id fields
      """
      def get_non_id_fields() do
        __MODULE__.__schema__(:fields) -- __MODULE__.__schema__(:primary_key)
      end

      defoverridable([changeset: 2, get_name_fields: 0])
    end
  end

end