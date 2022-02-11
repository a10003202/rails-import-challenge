require 'test_helper'

class PurchaseTest < ActiveSupport::TestCase
  def setup
    @purchase = purchases(:valid)
  end

  test 'valid item' do
    assert @purchase.valid?
  end

  test 'invalid without total_items' do
    @purchase.total_items = nil
    refute @purchase.valid?, 'saved item without total_items'
    assert_not_nil @purchase.errors[:total_items], 'no validation error for total_items present'
  end

  test 'invalid without total_price' do
    @purchase.total_price = nil
    refute @purchase.valid?, 'saved item without a total_price'
    assert_not_nil @purchase.errors[:total_price], 'no validation error for total_price present'
  end
end