# noinspection RubyResolve,RubyResolve
require_relative 'test_helper'
require 'logging'

Logging.logger.root.appenders = Logging.appenders.stdout

class MultibuyOfferTest < Minitest::Test

  def test_offer_empty_skus
    offer = MultibuyOffer.new('A', [{quantity: 3, reduction: 20},
                                    {quantity: 5, reduction: 50}])
    assert_equal 0, offer.apply([]), 'No reduction for no skus'
  end

  def test_offer_one_set
    offer = MultibuyOffer.new('A', [{quantity: 3, reduction: 20}])
    assert_equal 20, offer.apply(['A', 'A', 'A']), 'Reduction of 20 for one set of 3'
  end

  def test_offer_one_set_plus_one
    offer = MultibuyOffer.new('A', [{quantity: 3, reduction: 20}])
    assert_equal 20, offer.apply(['A', 'A', 'A', 'A']), 'Reduction of 20 for one set plus extra item'
  end

  def test_offer_two_sets
    offer = MultibuyOffer.new('A', [{quantity: 3, reduction: 20}])
    assert_equal 40, offer.apply(['A', 'A', 'A', 'A', 'A', 'A']), 'Reduction of 40 for two sets'
  end

  def test_offer_two_sets_plus_one
    offer = MultibuyOffer.new('A', [{quantity: 3, reduction: 20}])
    assert_equal 40, offer.apply(['A','A', 'A', 'A', 'A', 'A', 'A']), 'Reduction of 40 for two sets'
  end

  def test_offer_with_multiple_reductions_only_one_applied
    offer = MultibuyOffer.new('A', [{quantity: 5, reduction: 50},
                                    {quantity: 3, reduction: 20}])
    assert_equal 50, offer.apply(['A','A', 'A', 'A', 'A', 'A', 'A']), 'Reduction of 50 for six items'
  end

  def test_offer_with_multiple_reductions_both_applied
    offer = MultibuyOffer.new('A', [{quantity: 5, reduction: 50},
                                    {quantity: 3, reduction: 20}])
    assert_equal 70, offer.apply(['A','A', 'A', 'A', 'A', 'A', 'A', 'A']), 'Reduction of 70 for eight items'
  end

end
