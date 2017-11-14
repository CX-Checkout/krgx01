class App
  def checkout(skus)
    Checkout.new(skus).total
  end
end

class Checkout

  PRICE_TABLE = {
      'A' => 50,
      'B' => 30,
      'C' => 20,
      'D' => 15
  }

  def initialize(skus)
    @items = skus.split('')
  end

  def total
    return -1 unless items_valid?
    subtotal - discounts
  end

  def items_valid?
    @items.all? {|item| PRICE_TABLE.keys.include?(item)}
  end

  def subtotal
    @items.map {|item| PRICE_TABLE[item]}
        .reduce(0, :+)
  end

  def discounts
    total_discounts = 0
    a_discounts = @items.select {|i| i == 'A'}.each_slice(3).select {|x| x.length == 3}.count
    b_discounts = @items.select {|i| i == 'B'}.each_slice(2).select {|x| x.length == 2}.count
    total_discounts += 20 * a_discounts
    total_discounts += 15 * b_discounts
    total_discounts
  end

end
