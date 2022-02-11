class Purchase < ApplicationRecord
  belongs_to :buyer
  belongs_to :item
  belongs_to :seller

  validates :total_items, :total_price, presence: true
end
