require_relative 'multibuy_offer'

class Checkout

  MULTIBUY_OFFERS = [
      MultibuyOffer.new('A', [{quantity: 5, reduction: 50},
                              {quantity: 3, reduction: 20}]),
      MultibuyOffer.new('B', [{quantity: 2, reduction: 15}]),
      MultibuyOffer.new('H', [{quantity: 10, reduction: 20},
                              {quantity: 5, reduction: 5}]),
      MultibuyOffer.new('K', [{quantity: 2, reduction: 10}]),
      MultibuyOffer.new('P', [{quantity: 5, reduction: 50}]),
      MultibuyOffer.new('Q', [{quantity: 3, reduction: 10}]),
      MultibuyOffer.new('V', [{quantity: 3, reduction: 20},
                              {quantity: 2, reduction: 10}])
  ]
=begin

  BUY_X_GET_Y_FREE_OFFERS = AllBuyXGetYFree.new([
          BuyXGetYFree.new(buy: 'E', times: 2, get_free: 'B'),
          BuyXGetYFree.new(buy: 'F', times: 2, get_free: 'F'),
                          ])
=end

  PRICE_TABLE = {
      'A' => 50,
      'B' => 30,
      'C' => 20,
      'D' => 15,
      'E' => 40,
      'F' => 10,
      'G' => 20,
      'H' => 10,
      'I' => 35,
      'J' => 60,
      'K' => 80,
      'L' => 90,
      'M' => 15,
      'N' => 40,
      'O' => 10,
      'P' => 50,
      'Q' => 30,
      'R' => 50,
      'S' => 30,
      'T' => 20,
      'U' => 40,
      'V' => 50,
      'W' => 20,
      'X' => 90,
      'Y' => 10,
      'Z' => 50
  }

  def initialize(skus)
    @items = skus.split('')
  end

  def total
    return -1 unless items_valid?
    subtotal - offers
  end

  def items_valid?
    @items.all? { |item| PRICE_TABLE.keys.include?(item) }
  end

  def subtotal
    @items.map { |item| PRICE_TABLE[item] }
        .reduce(0, :+)
  end

  def offers
    item_quantities = histogram(@items)

    total = [
        { x: 'E', quantity: 2, y: 'B'},
        { x: 'F', quantity: 3, y: 'F'},
        { x: 'N', quantity: 3, y: 'M'},
        { x: 'R', quantity: 3, y: 'Q'},
        { x: 'U', quantity: 4, y: 'U'}
    ].map do |offer|
      apply_offer(offer[:x], offer[:quantity], offer[:y], item_quantities)
    end.reduce(0, :+)

    items = item_quantities.flat_map { |k, v| Array.new(v, k) }
    total + multibuy_offers(items)
  end

  def histogram(items)
    Hash[*items.group_by {|v| v}
              .flat_map {|k, v| [k, v.size]}]
  end

  def apply_offer(x, quantity, y, item_quantities)
    total = 0
    if @items.count(x) >= quantity && @items.include?(y)
      count = @items.select { |i| i == x }
                    .each_slice(quantity)
                    .select { |slice| slice.length == quantity }
                    .count
      while item_quantities[y] > 0 && count > 0
        total += PRICE_TABLE[y]
        count -= 1
        item_quantities[y] -= 1
      end
    end
    total
  end

  def multibuy_offers(items)
    MULTIBUY_OFFERS.map {|offer| offer.apply(items)}
        .reduce(0, :+)
  end
end
