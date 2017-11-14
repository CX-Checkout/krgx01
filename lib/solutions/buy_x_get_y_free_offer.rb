class BuyXGetYFreeOffer
  def initialize(x: x, quantity: quantity, y: y)
    @x = x
    @quantity = quantity
    @y = y
  end
  def apply(item_quantities, price_table)
    puts "BuyXGetYFreeOffer #{@x}, #{item_quantities}"
    total = 0
    items = flatten_histogram(item_quantities)
    if items.count(@x) >= @quantity && items.include?(@y)
      count = items.select { |i| i == @x }
                  .each_slice(@quantity)
                  .select { |slice| slice.length == @quantity }
                  .count
      while item_quantities[@y] > 0 && count > 0
        total += price_table[@y]
        count -= 1
        item_quantities[@y] -= 1
      end
    end
    total
  end

  def flatten_histogram(item_quantities)
    item_quantities.flat_map { |k, v| Array.new(v, k) }
  end

end
