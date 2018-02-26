# CheckoutProcess

This package is a https://github.com/cabify/rubyChallenge challenge solution in Elixir.

Elixir version is 1.6.1

## Installation

```
  git clone git@github.com:Landria/checkout_process.git
  cd checkout_process
  mix test
  mix compile
```

## Usage

Now you can run iex to try the package:
```
$ iex -S mix
```

Example:

```
iex(1)> products = [
...(1)>   %{:code => "VOUCHER", :name => "Cabify Voucher", :price => "5.00€"},
...(1)>   %{:code => "TSHIRT", :name => "Cabify T-Shirt", :price => "20.00€"},
...(1)>   %{:code => "MUG", :name => "Cafify Coffee Mug", :price => "7.50€"}
...(1)> ]
[
  %{code: "VOUCHER", name: "Cabify Voucher", price: "5.00€"},
  %{code: "TSHIRT", name: "Cabify T-Shirt", price: "20.00€"},
  %{code: "MUG", name: "Cafify Coffee Mug", price: "7.50€"}
]
iex(2)> rules = [ CheckoutProcess.TwoForOnePricing.new("TSHIRT") ]
[%{pricing: "TwoForOne", product: "TSHIRT"}]
iex(3)> c = CheckoutProcess.new(products, rules)
#PID<0.121.0>
iex(4)> c |> CheckoutProcess.scan("VOUCHER")
:ok
iex(5)> c |> CheckoutProcess.scan("TSHIRT")
:ok
iex(6)> c |> CheckoutProcess.scan("VOUCHER")
:ok
iex(7)> c |> CheckoutProcess.scan("TSHIRT")
:ok
iex(8)> c |> CheckoutProcess.scan("TSHIRT")
:ok
iex(9)> c |> CheckoutProcess.read_cart()
["TSHIRT", "TSHIRT", "VOUCHER", "TSHIRT", "VOUCHER"]
iex(10)> c |> CheckoutProcess.total()
"50.00€"

```

## Notes

Solution is not production ready code. It's just an example of an Elixir code I'm able to write for now. I'm just learning this awesome language so please do not judge strictly.

The implementation is very simple. You should pass an array of products and an array of rules (or skip the rules) to checkout initalizer.

You can set up two types of pricing policies:

*XMorePricing* if you want to set a discount to specific product over x items.
*TwoForOnePricing* if you want to offer every second item for free

There is no error handling specified (!to be implemented within next iteration).

Nonexisting items are ignored at checkout process.
If several rules passed for the same product only the last will be applyed.
If several products with the same code exists only the first one will be found (we assume that products are uniq).

Code is oranized as a mix package to make it reusable.
API, Server and logic parts are separated into modules.
Different types of pricings can be easily added.
Database source can also be added without total refactoring (just add a source module and init on CheckoutProcess#new instead of input products variable and change product search function).
