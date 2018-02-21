defmodule CheckoutProcess.TwoForOnePricing do
  @moduledoc false

  @doc """
  Defining TwoForOnwPricing rule.
  """
  def new(product_code) do
    %{:product_code => product_code}
  end
end
