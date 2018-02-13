defmodule CheckoutProcessTest do
  use ExUnit.Case
  doctest CheckoutProcess

  test "greets the world" do
    assert CheckoutProcess.hello() == :world
  end
end
