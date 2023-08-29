class Vendor < ApplicationRecord
  validates :name, :description, :contact_name, :contact_phone, :credit_accepted, presence: true
  belongs_to :market
end
