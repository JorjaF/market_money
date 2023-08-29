class Market < ApplicationRecord
  validates :name, :street, :city, :county, :state, :zip, :lat, :lon, presence: true
  has_many :vendors
end
