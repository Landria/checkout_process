defmodule CheckoutProcessTest do
  use ExUnit.Case
  doctest CheckoutProcess

  setup _context do
    {:ok,
     [
       products: [
         %{:code => "VOUCHER", :name => "Cabify Voucher", :price => "5.00€"},
         %{:code => "TSHIRT", :name => "Cabify T-Shirt", :price => "20.00€"},
         %{:code => "MUG", :name => "Cafify Coffee Mug", :price => "7.50€"}
       ]
     ]}
  end

  test "calculates total with no rules", context do
    checkout = CheckoutProcess.new(context[:products])
    checkout |> CheckoutProcess.scan("VOUCHER")
    checkout |> CheckoutProcess.scan("VOUCHER")
    checkout |> CheckoutProcess.scan("TSHIRT")

    assert checkout |> CheckoutProcess.read_cart() == ["TSHIRT", "VOUCHER", "VOUCHER"]
    assert checkout |> CheckoutProcess.read_products() == context[:products]
    assert checkout |> CheckoutProcess.total() == "30.00€"
  end

  test "ignores nonexisting products", context do
    checkout = CheckoutProcess.new(context[:products])
    checkout |> CheckoutProcess.scan("TSHIRT")
    checkout |> CheckoutProcess.scan("MUG")
    checkout |> CheckoutProcess.scan("SUPERMUG")

    assert checkout |> CheckoutProcess.total() == "27.50€"
  end

  test "applyes 2-for-1 rule for VOUCHERS", context do
    rules = [CheckoutProcess.TwoForOnePricing.new("VOUCHER")]
    checkout = CheckoutProcess.new(context[:products], rules)

    assert checkout |> CheckoutProcess.read_rules() == rules

    checkout |> CheckoutProcess.scan("VOUCHER")
    checkout |> CheckoutProcess.scan("TSHIRT")
    checkout |> CheckoutProcess.scan("VOUCHER")
    checkout |> CheckoutProcess.scan("VOUCHER")

    assert checkout |> CheckoutProcess.total() == "30.00€"
  end

  test "applies x-more rule for TSHIRTs", context do
    rules = [CheckoutProcess.XMorePricing.new("TSHIRT", 3, 19.0)]
    checkout = CheckoutProcess.new(context[:products], rules)

    checkout |> CheckoutProcess.scan("TSHIRT")
    checkout |> CheckoutProcess.scan("TSHIRT")
    checkout |> CheckoutProcess.scan("TSHIRT")
    checkout |> CheckoutProcess.scan("VOUCHER")
    checkout |> CheckoutProcess.scan("TSHIRT")

    assert checkout |> CheckoutProcess.total() == "81.00€"
  end

  test "applies both x-more and 2-for-1", context do
    rules = [
      CheckoutProcess.TwoForOnePricing.new("VOUCHER"),
      CheckoutProcess.XMorePricing.new("TSHIRT", 3, 19.0)
    ]

    checkout = CheckoutProcess.new(context[:products], rules)
    checkout |> CheckoutProcess.scan("VOUCHER")
    checkout |> CheckoutProcess.scan("TSHIRT")
    checkout |> CheckoutProcess.scan("VOUCHER")
    checkout |> CheckoutProcess.scan("VOUCHER")
    checkout |> CheckoutProcess.scan("MUG")
    checkout |> CheckoutProcess.scan("TSHIRT")
    checkout |> CheckoutProcess.scan("TSHIRT")

    assert checkout |> CheckoutProcess.total() == "74.50€"
  end

  test "applies last passed rule for a product", context do
    rules = [
      CheckoutProcess.TwoForOnePricing.new("VOUCHER"),
      CheckoutProcess.XMorePricing.new("VOUCHER", 3, 2.0)
    ]

    checkout = CheckoutProcess.new(context[:products], rules)
    checkout |> CheckoutProcess.scan("VOUCHER")
    checkout |> CheckoutProcess.scan("VOUCHER")
    checkout |> CheckoutProcess.scan("VOUCHER")
    checkout |> CheckoutProcess.scan("VOUCHER")

    assert checkout |> CheckoutProcess.total() == "8.00€"
  end
end
