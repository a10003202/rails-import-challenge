require 'test_helper'

class SellerTest < ActiveSupport::TestCase
  def setup
    @seller = sellers(:valid)
  end

  test 'valid buyer' do
    assert @seller.valid?
  end

  test 'invalid without name' do
    @seller.name = nil
    refute @seller.valid?, 'saved seller without a name'
    assert_not_nil @seller.errors[:name], 'no validation error for name present'
  end
end