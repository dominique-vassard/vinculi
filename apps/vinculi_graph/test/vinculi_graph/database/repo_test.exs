defmodule VinculiGraph.Database.RepoTest do
  @moduledoc """
  Test Repo features
  """
  use VinculiGraph.DatabaseCase
  alias VinculiGraph.TestPerson

  @valid_changes %{
    firstName: "Test_firstName",
    lastName: "Test_lastname",
    uuid: Ecto.UUID.generate()
  }

  @invalid_changes %{
    firstName: "T",
  }

  describe "Test the `get` functions: " do
    test "[get!] single node based on uuid" do
      changes = insert_test_person(%{uuid: "TestPerson-1"})

      res = Repo.get!(TestPerson, "TestPerson-1")
      check_node(res, %{labels: ["TestPerson"], properties: changes})
    end

    test "[get] single node based on uuid" do
      changes = insert_test_person(%{uuid: "TestPerson-2"})

      res = Repo.get(TestPerson, "TestPerson-2")
      check_node(res, %{labels: ["TestPerson"], properties: changes})
    end

    test "try to [get!] non-existent node raise an error" do
      assert_raise Ecto.NoResultsError, fn ->
        Repo.get!(TestPerson, "non-existent-node")
      end
    end

    test "try to [get] non-existent node raise an error" do
       r = Repo.get(TestPerson, "non-existent-node")
       assert r == nil
    end

    test "get_fuzzy_by/2 on existing value should return a result" do
      changes = insert_test_person(%{uuid: "TestPerson-3"})

      res = Repo.get_fuzzy_by TestPerson, %{firstName: "Test"}
      check_node(res, %{labels: ["TestPerson"], properties: changes})
    end

    test "get_fuzzy_by/2 is non case sensitive" do
      changes = insert_test_person(%{uuid: "TestPerson-4"})

      res = Repo.get_fuzzy_by TestPerson, %{firstName: "test"}
      check_node(res, %{labels: ["TestPerson"], properties: changes})
    end

    test "get_fuzzy_by/2 is performing an OR" do
      changes = insert_test_person(%{uuid: "TestPerson-4"})

      res = Repo.get_fuzzy_by TestPerson, %{firstName: "test", lastName: "Z"}
      check_node(res, %{labels: ["TestPerson"], properties: changes})
    end

    test "get_fuzzy_by/2 returns [] when no results found" do
      changes = insert_test_person(%{uuid: "TestPerson-5"})

      res = Repo.get_fuzzy_by TestPerson, %{firstName: "nonexisting"}
      check_node(res, [])
    end
  end

  describe "Test the `insert` functions: " do
    test "successful insert() of a new node" do
      {res, r} = %TestPerson{}
      |> TestPerson.changeset(@valid_changes)
      |> Repo.insert()
      assert res == :ok
      check_node(r, %{labels: ["TestPerson"], properties: @valid_changes})
    end

    test "successful insert!() of a new node" do
      r = %TestPerson{}
      |> TestPerson.changeset(@valid_changes)
      |> Repo.insert!()
      check_node(r, %{labels: ["TestPerson"], properties: @valid_changes})
    end

    test "insert() invalid changeset returns an error" do
      {res, r} = %TestPerson{}
      |> TestPerson.changeset(@invalid_changes)
      |> Repo.insert()
      assert res == :error
      refute r.valid?
    end

    test "insert!() invalid changeset raises an error" do
      r = %TestPerson{}
      |> TestPerson.changeset(@invalid_changes)
      assert_raise Ecto.InvalidChangesetError, fn -> Repo.insert!(r) end
    end

    test "Impossible to create 2 nodes with same uuid" do
      changes = Map.put(@valid_changes, :uuid, "TestPerson-1")
      changeset = %TestPerson{}
      |> TestPerson.changeset(changes)
      r = Repo.insert!(changeset)
      r2 = Repo.insert!(changeset)

      assert r == r2
    end
  end

  describe "Test the [query] function: " do
    test "successful query with one result returns a list of one result" do
      cql = "MATCH (n:TestPerson {uuid: {uuid}}) RETURN n"
      params = %{uuid: "test-query-1"}

      changes = insert_test_person(params)

      {res, r} = Repo.query(cql, params)
      assert res == :ok
      assert [%{"n" => result}] = r
      check_node(result, %{labels: ["TestPerson"], properties: changes})
    end

    test "successful query with multiple result returns a list of results" do
      cql = "MATCH (n:TestPerson {lastName: {lastName}}) RETURN n"
      params = %{lastName: "TESTQUERY2"}

      changes = for _ <- 1..:rand.uniform(15), do: insert_test_person(params)
      {res, r} = Repo.query(cql, params)
      assert res == :ok
      assert length(changes) == length(r)
      check_multiple_nodes(r, changes)
    end

    test "Can query with no params" do
      cql = "MATCH (n:TestPerson {uuid: 'test-query-3'}) RETURN n"

      changes = insert_test_person(%{uuid: "test-query-3"})

      {res, r} = Repo.query(cql)
      assert res == :ok
      assert [%{"n" => result}] = r
      check_node(result, %{labels: ["TestPerson"], properties: changes})
    end

    test "invalid query (syntax) raises an error" do
      cql = " MATC (n:TestPerson) RETURN n LIMIT 1"
      assert_raise Bolt.Sips.Exception, fn ->
        Repo.query(cql)
      end
    end

    test "invalid query (missing params) raises an error" do
      cql = "MATCH (n:TestPerson {uuid: {uuid}}) RETURN n"
      assert_raise Bolt.Sips.Exception, fn ->
        r = Repo.query(cql)
        IO.puts inspect r
      end
    end

    test "invalid query (too many params) raises an error" do
      cql = "MATCH (n:TestPerson {uuid: {uuid}}) RETURN n"
      params = %{uuid: "test-query-1", unused: "dumb"}

      assert_raise Bolt.Sips.Exception, fn ->
        Repo.query(cql, params)
      end
    end

    test "invalid query (invalid params) raises an error" do
      cql = "MATCH (n:TestPerson {uuid: {uuid}}) RETURN n"
      params = %{wrong_name: "test-query-1"}

      assert_raise Bolt.Sips.Exception, fn ->
        Repo.query(cql, params)
      end
    end
  end

  describe "Test the [one] function: " do
    test "successful query with one result returns this result" do
      cql = "MATCH (n:TestPerson {uuid: {uuid}}) RETURN n"
      params = %{uuid: "test-one-1"}

      changes = insert_test_person(params)

      res = Repo.one(cql, params)
      check_node(res, %{labels: ["TestPerson"], properties: changes})
    end

    test "Can be used without params" do
      cql = "MATCH (n:TestPerson {uuid: 'test-one-2'}) RETURN n"

      changes = insert_test_person(%{uuid: "test-one-2"})

      res = Repo.one(cql)
      check_node(res, %{labels: ["TestPerson"], properties: changes})
    end

    test "raises an exception if there is more than one result" do
      cql = "MATCH (n:TestPerson {lastName: {lastName}}) RETURN n"
      params = %{lastName: "TESTONE2"}

      for _ <- 1..(1 + :rand.uniform(15)), do: insert_test_person(params)
      assert_raise Ecto.MultipleResultsError, fn ->
        Repo.one(cql, params)
      end
    end

    test "returns nil if there is no result" do
      cql = "MATCH (n:TestPerson {uuid: {uuid}}) RETURN n"
      params = %{uuid: "non-exists"}


      assert nil == Repo.one(cql, params)
    end

    test "raises an exception in an error occured" do
      cql = "MATC (n:TestPerson {uuid: {uuid}}) RETURN n"
      params = %{uuid: "non-exists"}

      assert_raise Bolt.Sips.Exception, fn ->
        Repo.one(cql, params)
      end
    end
  end

  describe "Test the [one!] function: " do
    test "successful query with one result returns this result" do
      cql = "MATCH (n:TestPerson {uuid: {uuid}}) RETURN n"
      params = %{uuid: "test-onebang-1"}

      changes = insert_test_person(params)

      res = Repo.one!(cql, params)
      check_node(res, %{labels: ["TestPerson"], properties: changes})
    end

    test "Can be used without params" do
      cql = "MATCH (n:TestPerson {uuid: 'test-onebang-2'}) RETURN n"

      changes = insert_test_person(%{uuid: "test-onebang-2"})

      res = Repo.one!(cql)
      check_node(res, %{labels: ["TestPerson"], properties: changes})
    end

    test "raises an exception if there is more than one result" do
      cql = "MATCH (n:TestPerson {lastName: {lastName}}) RETURN n"
      params = %{lastName: "TESTONE!3"}

      for _ <- 1..(1 + :rand.uniform(15)), do: insert_test_person(params)
      assert_raise Ecto.MultipleResultsError, fn ->
        Repo.one!(cql, params)
      end
    end

    test "raises an error if there is no result" do
      cql = "MATCH (n:TestPerson {uuid: {uuid}}) RETURN n"
      params = %{uuid: "non-exists"}

      assert_raise Ecto.NoResultsError, fn ->
        Repo.one!(cql, params)
      end
    end

    test "raises an exception in an error occured" do
      cql = "MATC (n:TestPerson {uuid: {uuid}}) RETURN n"
      params = %{uuid: "non-exists"}

      assert_raise Bolt.Sips.Exception, fn ->
        Repo.one(cql, params)
      end
    end
  end

  describe "Test the [all] function" do
    test "successful query with one result returns a list of one result" do
      cql = "MATCH (n:TestPerson {uuid: {uuid}}) RETURN n"
      params = %{uuid: "test-all-1"}

      changes = insert_test_person(params)

      res = Repo.all(cql, params)
      assert [%{"n" => result}] = res
      check_node(result, %{labels: ["TestPerson"], properties: changes})
    end

    test "successful query with multiple result returns a list of results" do
      cql = "MATCH (n:TestPerson {lastName: {lastName}}) RETURN n"
      params = %{lastName: "TESTALL2"}

      changes = for _ <- 1..:rand.uniform(15), do: insert_test_person(params)
      res = Repo.all(cql, params)
      assert length(changes) == length(res)
      check_multiple_nodes(res, changes)
    end

    test "Can query with no params" do
      cql = "MATCH (n:TestPerson {uuid: 'test-all-3'}) RETURN n"

      changes = insert_test_person(%{uuid: "test-all-3"})

      res = Repo.all(cql)
      assert [%{"n" => result}] = res
      check_node(result, %{labels: ["TestPerson"], properties: changes})
    end
  end

  describe "Test the [check_params] function: " do
    test "returns `nil` if params are valid" do
      cql = "MATCH (n:Post {uuid: {uuid}}) RETURN n"
      assert nil == Repo.check_params(cql, %{uuid: "unique_id"})
    end

    test "raises an error if a param is missing" do
      cql = "MATCH (n:Post {uuid: {uuid}}) RETURN n"
      assert_raise Bolt.Sips.Exception, fn ->
        Repo.check_params(cql, %{})
      end
    end

    test "raises an error if a param is invalid" do
      cql = "MATCH (n:Post {uuid: {uuid}}) RETURN n"
      assert_raise Bolt.Sips.Exception, fn ->
        Repo.check_params(cql, %{invalid: "dumb"})
      end
    end

    test "raises an error if there is too much params" do
      cql = "MATCH (n:Post {uuid: {uuid}}) RETURN n"
      assert_raise Bolt.Sips.Exception, fn ->
        Repo.check_params(cql, %{uuid: "unique_id", unused: "wasted"})
      end
    end
  end

  @doc """
  Test the retrieved node

  ### Paramters

    - node_data: The data of the node to check (should be a %Bolt.Sips.Node
    struct)

  ### Returns
    - assertion result
  """
  def check_node(node_data, %{labels: labels, properties: props}) do
    node_props = node_data.properties
    |> Enum.map(fn {k, v} -> {String.to_atom(k), v} end)
    |> Enum.into(%{})
    assert node_data.labels == labels
    assert node_props == props
  end

  @doc """
  Check multiple nodes validity. Uses `check_node/2`
  """
  def check_multiple_nodes([%{"n" => cur_node}|nodes], [cur_change|changes]) do
    check_node(cur_node, %{labels: ["TestPerson"], properties: cur_change})
    check_multiple_nodes(nodes, changes)
  end
  def check_multiple_nodes([],[]),do: true
end
