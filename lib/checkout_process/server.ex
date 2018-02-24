defmodule CheckoutProcess.Server do

  use GenServer

  alias CheckoutProcess.Impl

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
    total = Enum.reduce(state[:cart], 0, fn product, acc -> acc + Impl.get_price(product, state) end)
    {:reply, Impl.printable_total(total), state}
  end
end
