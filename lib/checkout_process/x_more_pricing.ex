defmodule CheckoutProcess.XMorePricing do
  @moduledoc false

  @doc """
  Defining XMorePricing rule.
  """
  def new(product_code, border_quantity, new_price) do
    %{:product_code => product_code, border_quantity: border_quantity, new_price: new_price}
  end
end
