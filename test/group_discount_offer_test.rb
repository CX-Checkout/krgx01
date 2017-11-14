# noinspection RubyResolve,RubyResolve
require_relative 'test_helper'
require 'logging'

Logging.logger.root.appenders = Logging.appenders.stdout

class GroupDiscountOfferTest < Minitest::Test

  PRICE_TABLE = {
      'S' => 20,
      'T' => 20,
      'X' => 17,
      'Y' => 20,
      'Z' => 21
  }

  def test_offer_empty_skus
    offer = GroupDiscountOffer.new('STXYZ', 45, 3)
    assert_equal 0, offer.apply({}, PRICE_TABLE), 'No reduction for no skus'
  end

  def test_offer_other_skus
    offer = GroupDiscountOffer.new('STXYZ', 45, 3)
    assert_equal 0, offer.apply({'A'=>5}, PRICE_TABLE), 'No reduction for no skus'
  end

  def test_offer_one_of_each_same_price_missing_one
    offer = GroupDiscountOffer.new('STXYZ', 45, 3)
    assert_equal 0, offer.apply({'S' => 1, 'T' => 1, 'Y' => 0}, PRICE_TABLE), 'Reduces price to equivalent of 45'
  end

  def test_offer_one_of_each_same_price
    offer = GroupDiscountOffer.new('STXYZ', 45, 3)
    assert_equal 15, offer.apply({'S' => 2, 'T' => 2, 'Y' => 1}, PRICE_TABLE), 'Reduces price to equivalent of 45'
  end

  def test_offer_two_of_each_same_price
    offer = GroupDiscountOffer.new('STXYZ', 45, 3)
    assert_equal 30, offer.apply({'S' => 2, 'T' => 2, 'Y' => 2}, PRICE_TABLE), 'Reduces price to equivalent of 45'
  end

  def test_offer_three_of_each_same_price
    offer = GroupDiscountOffer.new('STXYZ', 45, 3)
    assert_equal 45, offer.apply({'S' => 3, 'T' => 3, 'Y' => 3}, PRICE_TABLE), 'Reduces price to equivalent of 45'
  end

  def test_offer_cheaper_item
    offer = GroupDiscountOffer.new('STXYZ', 45, 3)
    assert_equal 12, offer.apply({'S' => 1, 'T' => 1, 'X' => 1}, PRICE_TABLE), 'Reduces price to equivalent of 45'
  end

  def test_more_expensive_item
    offer = GroupDiscountOffer.new('STXYZ', 45, 3)
    assert_equal 16, offer.apply({'S' => 1, 'T' => 1, 'Y' => 1}, PRICE_TABLE), 'Reduces price to equivalent of 45'
  end

  def test_offer_give_best_price
    offer = GroupDiscountOffer.new('STXYZ', 45, 3)
    assert_equal 16, offer.apply({'S' => 1, 'T' => 1, 'Y' => 1, 'X' => 1, 'Z' => 1}, PRICE_TABLE), 'Reduces price to equivalent of 45'
  end

  def test_group_multibuy_stx
    offer = GroupDiscountOffer.new('STXYZ', 45, 3)
    assert_equal 12, offer.apply({'S' => 1, 'T' => 1, 'Y' => 1}, PRICE_TABLE)
  end

  def test_group_multibuy_stxstx
    offer = GroupDiscountOffer.new('STXYZ', 45, 3)
    assert_equal 24, offer.apply({'S' => 2, 'T' => 2, 'Y' => 2}, PRICE_TABLE)
  end

  def test_group_multibuy_sss
    offer = GroupDiscountOffer.new('STXYZ', 45, 3)
    assert_equal 15, offer.apply({'S' => 3}, PRICE_TABLE)
  end


  def test_offer_give_lots_of_combinations
    offer = GroupDiscountOffer.new('STXYZ', 45, 3)
    assert_equal 45, offer.apply({'S' => 1, 'T' => 1, 'Y' => 3, 'X' => 1, 'Z' => 3}, PRICE_TABLE), 'Reduces price to equivalent of 45'
  end


end
