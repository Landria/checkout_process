defmodule CheckoutProcess do

  @moduledoc """
  API
  """

  @doc """
  Start CheckoutProcrss process with initial products and rules
  """
  def new(products, rules \\ []) do
    {:ok, pid} =
      GenServer.start_link(CheckoutProcess.Server, %{
        :cart => [],
        :products => products,
        :rules => rules
      })

    pid
  end

  @doc """
  Add product to cart
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
  Get the products state
  """
  def read_products(pid) do
    GenServer.call(pid, {:read_products})
  end

  @doc """
  Get the rules state
  """
  def read_rules(pid) do
    GenServer.call(pid, {:read_rules})
  end

  @doc """
  Returns printable total sum
  """
  def total(pid) do
    GenServer.call(pid, {:calculate_cart_total})
  end
end
