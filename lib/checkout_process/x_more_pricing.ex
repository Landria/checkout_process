defmodule CheckoutProcess.XMorePricing do
  @moduledoc """
  Defining XMorePricing rule.
  """

  @doc """
  Initializing XMorePricing rule.
  """
  def new(product, border_quantity, new_price) do
    %{
      :pricing => "XMore",
      :product => product,
      :border_quantity => border_quantity,
      :new_price => new_price
    }
  end

  @doc """
  Calculating product subtotal according to XMore pricing policy.
  """
  def sub_total(price, quantity, rule) do
    if quantity >= rule[:border_quantity] do
      rule[:new_price] * quantity
    else
      price * quantity
    end
  end
end
