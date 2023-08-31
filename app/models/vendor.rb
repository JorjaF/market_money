class Vendor < ApplicationRecord
  validates :name, :description, :contact_name, :contact_phone, presence: true
  belongs_to :market

  validate :credit_accepted_presence

  private

  def credit_accepted_presence
    unless credit_accepted.is_a?(TrueClass) || credit_accepted.is_a?(FalseClass)
      errors.add(:credit_accepted, "must be true or false")
    end
  end

  def credit_accepted_cannot_be_nil
    if credit_accepted.nil?
      errors.add(:credit_accepted, "can't be blank")
    end
  end
end
