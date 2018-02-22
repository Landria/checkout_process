defmodule CheckoutProcess do
  use GenServer

  # Client

  @moduledoc false

  @doc """
  Start CheckoutProcrss process.
  """
  def new(products, rules \\ []) do
    {:ok, pid} =
      GenServer.start_link(__MODULE__, %{:cart => [], :products => products, rules: rules})

    pid
  end

  @doc """
  Add product to cart for checkout
  """
  def scan(pid, product_code) do
    GenServer.cast(pid, {:add_product_to_cart, product_code})
  end

  @doc """
  Get the cart state
  """
  def read_cart(pid) do
    GenServer.call(pid, {:read_cart})
  end

  @doc """
  Initialize products
  """
  def init_products(pid, products) do
    GenServer.cast(pid, {:add_products, products})
  end

  @doc """
  Get the products state
  """
  def read_products(pid) do
    GenServer.call(pid, {:read_products})
  end

  @doc """
  Return printable total sum
  """
  def total(pid) do
    GenServer.call(pid, {:calculate_cart_total})
  end

  # Server
  def init(args) do
    {:ok, args}
  end

  def handle_cast({:add_product_to_cart, code}, state) do
    updated_state = Map.put(state, :cart, [code] ++ state[:cart])
    {:noreply, updated_state}
  end

  def handle_cast({:add_products, products}, state) do
    if Map.has_key?(state, :products) do
      {:noreply, state}
    else
      {:noreply, Map.put(state, :products, products)}
    end
  end

  def handle_call({:read_cart}, _, state) do
    {:reply, state[:cart], state}
  end

  def handle_call({:read_products}, _, state) do
    {:reply, state[:products], state}
  end

  def handle_call({:calculate_cart_total}, _, state) do
    total = Enum.reduce(state[:cart], 0, fn product, acc -> acc + get_price(product, state) end)
    {:reply, printable_total(total), state}
  end

  def get_price(product, state) do
    Enum.find(state[:products], %{price: "0.0€"}, fn element ->
      element[:code] == product
    end)
    |> Map.get(:price)
    |> String.replace("€", "")
    |> String.to_float()
  end

  def printable_total(total) do
    "#{:erlang.float_to_binary(total, decimals: 2)}€"
  end
end