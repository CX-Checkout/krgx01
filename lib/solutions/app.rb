require_relative 'checkout'

class App
  def checkout(skus)
    puts skus
    Checkout.new(skus).total
  end
end
