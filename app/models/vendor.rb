class Vendor < ApplicationRecord
  validates :name, :description, :contact_name, :contact_phone, presence: true
  belongs_to :market

  validate :credit_accepted_presence

  private

  def credit_accepted_presence
    if credit_accepted.nil?
      errors.add(:credit_accepted, "must be true or false")
    end
  end
end
