class MultibuyOffer
  def initialize(sku, reductions)
    @sku = sku
    @reductions = reductions
  end

  def apply(items)
    items = items.dup.select { |item| item == @sku }
    @reductions.reduce(0) do |total, reduction|
      offer_quantity = offer_quantity(items, reduction)
      items = items.drop(reduction[:quantity] * offer_quantity)
      total + (reduction[:reduction] * offer_quantity)
    end
  end

  def offer_quantity(items, reduction)
    items.each_slice(reduction[:quantity])
        .select { |x| x.length == reduction[:quantity] }
        .count
  end

end