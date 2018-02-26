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

  def handle_call({:read_rules}, _, state) do
    {:reply, state[:rules], state}
  end

  def handle_call({:calculate_cart_total}, _, state) do
    total =
      state[:cart]
      |> Enum.reduce(%{}, fn(product, acc) -> Map.update(acc, product, 1, &(&1 + 1)) end)
      |> Enum.reduce(0, fn({product, quantity}, acc) ->
        acc + Impl.sub_total(Impl.get_price(product, state), quantity, Impl.get_rule(product, state))
      end)

    {:reply, Impl.printable_total(total), state}
  end
end