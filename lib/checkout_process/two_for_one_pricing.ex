defmodule CheckoutProcess.TwoForOnePricing do
  @moduledoc false

  require Integer

  @doc """
  Defining TwoForOnwPricing rule.
  """
  def new(product) do
    %{:pricing => "TwoForOne", :product => product}
  end

  def sub_total(price, quantity) do
    payable_quantity = if Integer.is_even(quantity), do: div(quantity, 2) , else: div(quantity, 2) + 1
    payable_quantity * price
  end
end
