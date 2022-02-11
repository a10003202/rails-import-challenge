require 'test_helper'

class BuyerTest < ActiveSupport::TestCase
  def setup
    @buyer = buyers(:valid)
  end

  test 'valid buyer' do
    assert @buyer.valid?
  end

  test 'invalid without name' do
    @buyer.name = nil
    refute @buyer.valid?, 'saved buyer without a name'
    assert_not_nil @buyer.errors[:name], 'no validation error for name present'
  end
end