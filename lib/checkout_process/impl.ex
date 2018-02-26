defmodule CheckoutProcess.Impl do
  alias CheckoutProcess.TwoForOnePricing
  alias CheckoutProcess.XMorePricing

  @moduledoc """
  Checkout process implementation
  """

  @doc """
  Searching for product by name to get it's price.

  Returns float value of product price.
  """
  def get_price(product, state) do
    product =
      Enum.find(state[:products], %{price: "0.0€"}, fn element ->
        element[:code] == product
      end)

    product
    |> Map.get(:price)
    |> String.replace("€", "")
    |> String.to_float()
  end

  @doc """
  Calculating cart total with all pricing rules applyed (or without rules).

  Returns cost of all products in a cart.
  """
  def total(state) do
    state[:cart]
    |> Enum.reduce(%{}, fn product, acc -> Map.update(acc, product, 1, &(&1 + 1)) end)
    |> Enum.reduce(0, fn {product, quantity}, acc ->
      acc +
        sub_total(get_price(product, state), quantity, get_rule(product, state))
    end)
  end

  @doc """
  Calculating product subtotal with specified rule (or without rule).

  Returns cost of a product items in a cart.
  """
  def sub_total(price, quantity, rule) do
    case rule[:pricing] do
      "TwoForOne" ->
        TwoForOnePricing.sub_total(price, quantity)

      "XMore" ->
        XMorePricing.sub_total(price, quantity, rule)

      nil ->
        price * quantity
    end
  end

  @doc """
  Returns string representation of cart total.
  """
  def printable_total(total) do
    "#{:erlang.float_to_binary(total, decimals: 2)}€"
  end

  @doc """
  Searching for a rule specified for a product

  Returns map as a rule if found.
  """
  def get_rule(product, state) do
    Enum.filter(state[:rules], fn element ->
      element[:product] == product
    end)
    |> List.last()
  end
end
