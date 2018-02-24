defmodule CheckoutProcess.Impl do

  # Checkout process implementation

  @moduledoc false

  def get_price(product, state) do
    product = Enum.find(state[:products], %{price: "0.0€"}, fn element ->
      element[:code] == product
    end)

    product
      |> Map.get(:price)
      |> String.replace("€", "")
      |> String.to_float()
  end

  def printable_total(total) do
    "#{:erlang.float_to_binary(total, decimals: 2)}€"
  end
end
