class Item < ApplicationRecord
  validates :description, :price, presence: true
end
