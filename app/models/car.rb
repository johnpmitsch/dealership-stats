class Car < ActiveRecord::Base
  validates :price, :date_sold, presence: true
end
