require "rails_helper"

RSpec.describe Vendor, type: :model do
  describe "relationships" do
    it { should belong_to (:market) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description)}
    it { should validate_presence_of(:contact_name) }
    it { should validate_presence_of(:contact_phone) }
  end
end
