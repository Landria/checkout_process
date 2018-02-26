defmodule CheckoutProcess.TwoForOnePricing do
  @moduledoc """
  Defining TwoForOnePricing rule.
  """

  require Integer

  @doc """
  Initializing TwoForOnePricing rule.
  """
  def new(product) do
    %{:pricing => "TwoForOne", :product => product}
  end

  @doc """
  Calculating product subtotal according to TwoForOne pricing policy.
  """
  def sub_total(price, quantity) do
    payable_quantity =
      if Integer.is_even(quantity), do: div(quantity, 2), else: div(quantity, 2) + 1

    payable_quantity * price
  end
end
