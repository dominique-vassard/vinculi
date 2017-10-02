defmodule VinculiGraph.Repo do
  @moduledoc """
  Emulates Ecto.Repo for common operation (Uses Bolt.Sips for query)
  """

  alias VinculiGraph.Meta.Node

  @doc """
  Inserts a changeset

  It returns `{:ok, Bolt.Sips.Node}` if successful, or
  `{:error, Bolt.Sips.Exception}` if an database/connection error occured, or
  `{:error, changeset}` if the changeset was invalid

  ### Examples
  A typical example:
      case BoltRepo.insert(%Post{title: "My new post"}) do
        {:ok, node} -> # Node created with success
        {:error, changeset} -> # Invalid changeset
      end
  """
  def insert(%Ecto.Changeset{} = changeset, opts \\ []) do
    do_insert(changeset, opts)
  end

  @doc """
  Same as `insert/2` but returns the struct or raises if the changeset is
  invalid.
  """
  def insert!(%Ecto.Changeset{} = changeset, opts \\ []) do
    case do_insert(changeset, opts) do
      {:ok, result} -> result
      {:error, changeset} ->
        raise Ecto.InvalidChangesetError, action: :insert, changeset: changeset
    end
  end

  defp do_insert(%Ecto.Changeset{valid?: true} = changeset, opts) do
    %{changes: data_to_insert, data: struct} = changeset
    node_label = struct.__struct__.__schema__(:source)
    {cql, params} = Node.get_cql_insert(node_label, data_to_insert)
    case query(cql, params, opts) do
      {:ok, [%{"n" => result}]} -> {:ok, result}
      {:error, error} -> {:error, error}
    end
  end
  defp do_insert(changeset, _opts) do
    {:error, changeset}
  end

  @doc """
  Launch the given query with params on database.

  Returns all found results, on raise a `Bolt.Sips.Exception` in case of error.

  As database errors should not be silently ignored, a wrong query will crash.

  ### Example
      BoltRepo.query("MATCH (n:Post {uuid: {uuid}}", %{uuid: "unique_id"})
  """
  def query(cql, params \\ %{}, _opts \\ []) do
    check_params(cql, params)
    tx_conn = Bolt.Sips.begin(Bolt.Sips.conn)
    res = Bolt.Sips.query(tx_conn, cql, params)
    case res do
      {:ok, result} ->
        Bolt.Sips.commit(tx_conn)
        {:ok, result}
      {:error, [code: code, message: message]} ->
        Bolt.Sips.rollback(tx_conn)
        raise Bolt.Sips.Exception, code: code, message: code <> ": " <> message
    end
  end

  @doc """
  Similar to `query/3` but cannot accept `opts`
  """
  def all(cql, params \\ %{}) do
    case query(cql, params) do
      {:ok, result} -> result
    end
  end

  @doc """
  Check if `params` are correct, considering the `cql`query.

  `params`must contians the right number od parameters and those parameters
  must have the same as in the query.

  Raises an error if `params` is invalid.

  ### Examples
      iex> cql = "MATCH (n:Post {uuid: {uuid}}) RETURN n"
      "MATCH (n:Post {uuid: {uuid}}) RETURN n"
      iex> BoltRepo.check_params(cql, %{uuid: "unique_id"})
      nil
      iex> BoltRepo.check_params(cql, %{})
      ** (Bolt.Sips.Exception)   Invalid parameters:
        -> from  query: [:uuid]
        -> from params: []


      iex> cql = "MATCH (n:Post {uuid: {uuid}}) RETURN n"
      "MATCH (n:Post {uuid: {uuid}}) RETURN n"
      iex> BoltRepo.check_params(cql, %{invalid: "dumb"})
      ** (Bolt.Sips.Exception)   Invalid parameters:
        -> from  query: [:uuid]
        -> from params: [:invalid]

      iex> cql = "MATCH (n:Post {uuid: {uuid}}) RETURN n"
      "MATCH (n:Post {uuid: {uuid}}) RETURN n"
      iex> BoltRepo.check_params(cql, %{uuid: "unique_id", unused: "wasted"})
      ** (Bolt.Sips.Exception)   Invalid parameters:
        -> from  query: [:uuid]
        -> from params: [:unused, :uuid]

  """
  def check_params(cql, params) do
    cql_params_names =
    Regex.scan(~r/{(\w+)}/, cql, capture: :all_but_first)
    |> List.flatten()
    |> Enum.map(&String.to_atom/1)
    |> Enum.sort()

    params_names = params
    |> Enum.map(fn {k, _v} -> k end)
    |> Enum.sort()

     unless cql_params_names == params_names do
      msg = """
        Invalid parameters:
        -> from  query: #{inspect cql_params_names}
        -> from params: #{inspect params_names}
      """
      raise Bolt.Sips.Exception, code: "Invalid params", message: msg
     end
  end

  @doc """
  Fetches a node for the given uuid

  Returns a `Bolt.Sips.Node` on success, `nil` if there is no result,
  `Ecto.MultipleResultsError` if there is more than one result

  ### Example
      BoltRepo.get(PostModel, "unique_id")
  """
  def get(model, uuid) do
    do_get(model, uuid)
  end

  @doc """
  Similar to `get/2` but raises `Ecto.NoResultsError` if no record was found.
  """
  def get!(model, uuid) do
    source = model.__schema__(:source)
    err_msg = "For label: [#{source}] and uuid [#{uuid}]"

    case do_get(model, uuid) do
      nil -> raise %Ecto.NoResultsError{message: err_msg}
      result -> result
    end
  end

  defp do_get(model, uuid) do
    source = model.__schema__(:source)
    one(Node.get_cql_get_by_uuid(source), %{uuid: uuid})
  end

  @doc """
  Fetches one result for the given cql and params

  Returns a `Bolt.Sips.Node` on success, `nil` if there is no result,
  `Ecto.MultipleResultsError` if there is more than one result

  ### Example
      BoltRepo.one("MATCH (n:Post {uuid: {uuid}}", %{uuid: "unique_id"})
  """
  def one(cql, params \\ %{}) do
    err_msg = cql <> " \n " <> inspect params

    case query(cql, params) do
      {:ok, [%{"n" => one}]} -> one
      {:ok, []} -> nil
      {:ok, _results} -> raise %Ecto.MultipleResultsError{message: err_msg}
    end
  end

  @doc """
  Similar to `one/2` but raises `Ecto.NoResultsError` if no record was found.
  """
  def one!(cql, params \\ %{}) do
    err_msg = cql <> " \n " <> inspect params

    case query(cql, params) do
      {:ok, [%{"n" => one}]} -> one
      {:ok, []} -> raise %Ecto.NoResultsError{message: err_msg}
      {:ok, _results} -> raise %Ecto.MultipleResultsError{message: err_msg}
    end
  end


end