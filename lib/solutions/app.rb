require_relative 'checkout'

class App
  def checkout(skus)
    Checkout.new(skus).total
  end
end
