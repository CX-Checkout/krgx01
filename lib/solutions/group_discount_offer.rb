# noinspection ALL
class GroupDiscountOffer
  def initialize(skus, reduced_price, combination_threshold)
    @skus = skus.split('')
    @reduced_price = reduced_price
    @combination_threshold = combination_threshold
    @combanitions = @skus.combination(combination_threshold).to_a
  end

  def apply(item_quantities, price_table)
    return 0 if item_quantities.empty?
    relevant_items = item_quantities.keep_if { |k, v| @skus.include?(k) }
    skus_sorted_by_price = @skus.sort { |a, b| price_table[b] <=> price_table[a] }
    offer_groups = []
    while !relevant_items.values.any? { |v| v == 0 }
      @combination_threshold.times do
        skus_sorted_by_price.each do |sku|
          next if relevant_items[sku] == 0
          next if relevant_items[sku].nil?
          while relevant_items[sku] > 0
            offer_groups.push(sku)
            relevant_items[sku] -= 1
          end
        end
      end
    end
    offer_groups.each_slice(@combination_threshold)
         .select {|group| group.length == @combination_threshold}
         .map {|group| group.map {|sku| price_table[sku]}.reduce(:+) - @reduced_price}
         .reduce(0, :+)
  end
end
