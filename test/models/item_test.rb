require 'test_helper'

class ItemTest < ActiveSupport::TestCase
  def setup
    @item = items(:valid)
  end

  test 'valid item' do
    assert @item.valid?
  end

  test 'invalid without description' do
    @item.description = nil
    refute @item.valid?, 'saved item without a description'
    assert_not_nil @item.errors[:description], 'no validation error for description present'
  end

  test 'invalid without price' do
    @item.price = nil
    refute @item.valid?, 'saved item without a price'
    assert_not_nil @item.errors[:price], 'no validation error for price present'
  end
end