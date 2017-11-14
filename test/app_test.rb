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
    assert_equal 180, app.checkout('AAAa'), 'Basket applies 20 discount for 3 As'
  end

  def test_special_multiple_offer_a
    assert_equal 260, app.checkout('AAAAAA'), 'Basket applies 20 discount for 3 As'
  end

  def test_special_offer_b
    assert_equal 45, app.checkout('BB'), 'Basket applies 15 discount for 2 Bs'
  end

  def test_special_multiple_offer_b
    assert_equal 45, app.checkout('BBB'), 'Basket applies 15 discount for 2 Bs'
  end

end
