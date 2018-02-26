defmodule CheckoutProcess.Impl do
  # Checkout process implementation

  alias CheckoutProcess.TwoForOnePricing
  alias CheckoutProcess.XMorePricing

  @moduledoc false

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

  def printable_total(total) do
    "#{:erlang.float_to_binary(total, decimals: 2)}€"
  end

  def get_rule(product, state) do
    Enum.filter(state[:rules], fn element ->
      element[:product] == product
    end)
    |> List.last()
  end
end
