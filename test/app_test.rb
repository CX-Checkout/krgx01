# noinspection RubyResolve,RubyResolve
require_relative 'test_helper'
require 'logging'

Logging.logger.root.appenders = Logging.appenders.stdout

class ClientTest < Minitest::Test

  def setup
    @app = App.new
  end

  attr_reader :app

  def test_empty_basket
    assert_equal 0, app.checkout(''), 'Basket costs 0 for no items'
  end

  def test_one_item
    assert_equal 50, app.checkout('A'), 'Basket cost 50 for item'
  end

  def test_two_item
    assert_equal 80, app.checkout('AB'), 'Basket cost 80 for one B, one A'
  end

  def test_all_item
    assert_equal 115, app.checkout('ABCD'), 'Basket cost 115 for each item'
  end

  def test_multiples_of_item
    assert_equal 140, app.checkout('AACC'), 'Basket handles multiples of an item'
  end

  def test_illegal_numeric_input
    assert_equal (-1), app.checkout('123'), 'Basket rejects illegal numeric input'
  end

  def test_whitespace_input
    assert_equal (-1), app.checkout('   '), 'Basket rejects illegal numeric input'
  end

  def test_noneexistant_item_input
    assert_equal (-1), app.checkout('FGH'), 'Basket rejects illegal input'
  end

  def test_special_offer_a
    assert_equal 130, app.checkout('AAA'), 'Basket applies 20 discount for 3 As'
  end

  def test_special_offer_3A_and_a
    assert_equal 180, app.checkout('AAAA'), 'Basket applies 20 discount for 4 As'
  end

  def test_special_multiple_offer_a
    assert_equal 200, app.checkout('AAAAA'), 'Basket applies 50 discount for 5 As'
  end

  def test_special_offer_b
    assert_equal 45, app.checkout('BB'), 'Basket applies 15 discount for 2 Bs'
  end

  def test_special_multiple_offer_b
    assert_equal 75, app.checkout('BBB'), 'Basket applies 15 discount for 2 Bs'
  end

  def test_buy_two_e_get_free_b
    assert_equal 80, app.checkout('EEB'), 'Basket applies 30 discount for 2 Es bought'
  end

  def test_buy_four_e_get_two_free_b
    assert_equal 160, app.checkout('EEEEBB'), 'Basket applies 60 discount for 4 Es and 2Bs bought'
  end

  def test_buy_two_e_get_one_b_free_and_reduce_b
    assert_equal 125, app.checkout('EEBBB'), 'Basket applies 60 discount for 4 Es and 2Bs bought'
  end

  def test_negative_index_exception
    assert_equal 665, app.checkout('ABCDECBAABCABBAAAEEAA'), 'No negative index exception'
  end

end
