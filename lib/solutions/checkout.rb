require_relative 'multibuy_offer'

class Checkout

  OFFERS = [
      MultibuyOffer.new('A', [{quantity: 5, reduction: 50},
                {quantity: 3, reduction: 20}]),
      MultibuyOffer.new('B', [{quantity: 2, reduction: 15}])
  ]

  PRICE_TABLE = {
      'A' => 50,
      'B' => 30,
      'C' => 20,
      'D' => 15,
      'E' => 40
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
    total = 0
    item_quantities = histogram(@items)

    if @items.count('E') >= 2 && @items.include?('B')
        e_count = @items.select { |i| i == 'E' }
        .each_slice(2)
        .select { |x| x.length == 2 }
        .count

        while item_quantities['B'] > 0 && e_count > 0
          total += 30
          e_count -= 1
          item_quantities['B'] -= 1
        end
    end
    items = item_quantities.flat_map { |k, v| Array.new(v, k) }
    multibuy_offers = OFFERS.map { |offer| offer.apply(items) }
                          .reduce(0, :+)
    total + multibuy_offers
  end

  def histogram(items)
    Hash[*items.group_by{ |v| v }
      .flat_map{ |k, v| [k, v.size] }]
  end

end
