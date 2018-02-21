defmodule CheckoutProcessTest do
  use ExUnit.Case
  doctest CheckoutProcess

  test "calculates total with no rules" do
    products = [
      %{:code => 'VOUCHER', :name => 'Cabify Voucher', :price => "5.00€"},
      %{:code => 'TSHIRT', :name => 'Cabify T-Shirt', :price => "20.00€"},
      %{:code => 'MUG', :name => 'Cafify Coffee Mug', :price => "7.50€"}
    ]

    checkout = CheckoutProcess.new()
    checkout |> CheckoutProcess.init_products(products)
    checkout |> CheckoutProcess.scan('VOUCHER')
    checkout |> CheckoutProcess.scan('VOUCHER')
    checkout |> CheckoutProcess.scan('TSHIRT')

    assert checkout |> CheckoutProcess.read_cart() == ['TSHIRT', 'VOUCHER', 'VOUCHER']
    assert checkout |> CheckoutProcess.read_products() == products
    assert checkout |> CheckoutProcess.total() == "30.00€"
  end
end