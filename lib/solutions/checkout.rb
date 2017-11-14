require_relative 'multibuy_offer'
require_relative 'buy_x_get_y_free_offer'
require_relative 'group_discount_offer'

class Checkout

  MULTIBUY_OFFERS = [
      MultibuyOffer.new('A', [{quantity: 5, reduction: 50},
                              {quantity: 3, reduction: 20}]),
      MultibuyOffer.new('B', [{quantity: 2, reduction: 15}]),
      MultibuyOffer.new('H', [{quantity: 10, reduction: 20},
                              {quantity: 5, reduction: 5}]),
      MultibuyOffer.new('K', [{quantity: 2, reduction: 20}]),
      MultibuyOffer.new('P', [{quantity: 5, reduction: 50}]),
      MultibuyOffer.new('Q', [{quantity: 3, reduction: 10}]),
      MultibuyOffer.new('V', [{quantity: 3, reduction: 20},
                              {quantity: 2, reduction: 10}])
  ]

  BUY_X_GET_Y_FREE_OFFERS = [
      BuyXGetYFreeOffer.new( x: 'E', quantity: 2, y: 'B'),
      BuyXGetYFreeOffer.new( x: 'F', quantity: 3, y: 'F'),
      BuyXGetYFreeOffer.new( x: 'N', quantity: 3, y: 'M'),
      BuyXGetYFreeOffer.new( x: 'R', quantity: 3, y: 'Q'),
      BuyXGetYFreeOffer.new( x: 'U', quantity: 4, y: 'U')
  ]

  THREE_OF_A_KIND_OFFER = [
      GroupDiscountOffer.new('STXYZ', 45, 3)
  ]

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
      'K' => 70,
      'L' => 90,
      'M' => 15,
      'N' => 40,
      'O' => 10,
      'P' => 50,
      'Q' => 30,
      'R' => 50,
      'S' => 20,
      'T' => 20,
      'U' => 40,
      'V' => 50,
      'W' => 20,
      'X' => 17,
      'Y' => 20,
      'Z' => 21
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
    buy_x_get_y_free = buy_x_get_y_free_offers(item_quantities)
    items = item_quantities.flat_map { |k, v| Array.new(v, k) }
    buy_x_get_y_free + multibuy_offers(items) + three_of_a_kind_offers(item_quantities)
  end

  def histogram(items)
    Hash[*items.group_by {|v| v}
              .flat_map {|k, v| [k, v.size]}]
  end

  def buy_x_get_y_free_offers(item_quantities)
    BUY_X_GET_Y_FREE_OFFERS.map {|offer| offer.apply(item_quantities, PRICE_TABLE)}
        .reduce(0, :+)
  end

  def multibuy_offers(items)
    MULTIBUY_OFFERS.map {|offer| offer.apply(items)}
        .reduce(0, :+)
  end

  def three_of_a_kind_offers(item_quantities)
    THREE_OF_A_KIND_OFFER.map { |offer| offer.apply(item_quantities, PRICE_TABLE) }
      .reduce(0, :+)
  end
end

