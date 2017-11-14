# noinspection RubyResolve,RubyResolve
require_relative 'test_helper'
require 'logging'

Logging.logger.root.appenders = Logging.appenders.stdout

class ClientTest < Minitest::Test

  def setup
    @app = App.new
  end

  attr_reader :app

  def test_empty_checkout
    assert_equal 0, app.checkout(''), 'Checkout costs 0 for no items'
  end

  def test_one_item
    assert_equal 50, app.checkout('A'), 'Checkout cost 50 for item'
  end

  def test_two_item
    assert_equal 80, app.checkout('AB'), 'Checkout cost 80 for one B, one A'
  end

  def test_all_item
    assert_equal 115, app.checkout('ABCD'), 'Checkout cost 115 for each item'
  end

  def test_multiples_of_item
    assert_equal 140, app.checkout('AACC'), 'Checkout handles multiples of an item'
  end

  def test_illegal_numeric_input
    assert_equal (-1), app.checkout('123'), 'Checkout rejects illegal numeric input'
  end

  def test_whitespace_input
    assert_equal (-1), app.checkout('   '), 'Checkout rejects illegal numeric input'
  end

  def test_nonexistent_item_input
    assert_equal (-1), app.checkout('xFGH'), 'Checkout rejects illegal input'
  end

  def test_special_offer_a
    assert_equal 130, app.checkout('AAA'), 'Checkout applies 20 discount for 3 As'
  end

  def test_special_offer_3A_and_a
    assert_equal 180, app.checkout('AAAA'), 'Checkout applies 20 discount for 4 As'
  end

  def test_special_multiple_offer_a
    assert_equal 200, app.checkout('AAAAA'), 'Checkout applies 50 discount for 5 As'
  end

  def test_special_offer_b
    assert_equal 45, app.checkout('BB'), 'Checkout applies 15 discount for 2 Bs'
  end

  def test_special_multiple_offer_b
    assert_equal 75, app.checkout('BBB'), 'Checkout applies 15 discount for 2 Bs'
  end

  def test_buy_two_e_get_free_b
    assert_equal 80, app.checkout('EEB'), 'Checkout applies 30 discount for 2 Es bought'
  end

  def test_buy_four_e_get_two_free_b
    assert_equal 160, app.checkout('EEEEBB'), 'Checkout applies 60 discount for 4 Es and 2Bs bought'
  end

  def test_buy_two_e_get_one_b_free_and_reduce_b
    assert_equal 125, app.checkout('EEBBB'), 'Checkout applies 60 discount for 4 Es and 2Bs bought'
  end

  def test_negative_index_exception
    assert_equal 665, app.checkout('ABCDECBAABCABBAAAEEAA'), 'No negative index exception'
  end

  def test_f_reduction
    assert_equal 20, app.checkout('FFF'), 'Checkout applies 10 discount for three Fs'
  end

  def test_multiple_f_reduction
    assert_equal 40, app.checkout('FFFFFF'), 'Checkout applies 20 discount for six Fs'
  end

  def test_multiple_f_reduction_plus_extra_f
    assert_equal 50, app.checkout('FFFFFFF'), 'Checkout applies 20 discount for seven Fs'
  end

  def test_buy_5h
    assert_equal 45, app.checkout('HHHHH'), 'Checkout applies 5 discount for five Hs'
  end

  def test_buy_10h
    assert_equal 80, app.checkout('HHHHHHHHHH'), 'Checkout applies 20 discount for ten Hs'
  end

  def test_buy_2k
    assert_equal 120, app.checkout('KK'), 'Checkout applies 20 discount for two Ks'
  end

  def test_u_reduction
    assert_equal 120, app.checkout('UUU'), 'Checkout applies 40 discount for three Us'
  end

  def test_group_multibuy_stx
    assert_equal 45, app.checkout('STX'), 'Checkout applies group price of 45 for combination of STX'
  end

  def test_group_multibuy_stxstx
    assert_equal 90, app.checkout('STXSTX'), 'Checkout applies group price of 45 for combination of STXSTX'
  end

  def test_group_multibuy_sss
    assert_equal 45, app.checkout('SSS'), 'Checkout applies group price of 45 for combination of SSS'
  end

  def test_error_case
    assert_equal 795, app.checkout('ABCDEFGHIJKLMNOPQRSTUVW'), 'ABD'
  end

end
