require "rails_helper"

RSpec.describe Market, type: :model do
  describe "relationships" do
    it { should have_many (:vendors) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:street) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:county) }
    it { should validate_presence_of(:state) }
    it { should validate_presence_of(:zip) }
    it { should validate_presence_of(:lat) }
    it { should validate_presence_of(:lon) }
  end

  describe "vendor_count" do
    it "can return a vendor count" do
      market1 = Market.create!(name: "Test Market 1", street: "123 Main St", city: "Denver", county: "Denver", state: "CO", zip: "80202", lat: 39.750833, lon: -104.996944)
      market2 = Market.create!(name: "Test Market 2", street: "456 Main St", city: "Denver", county: "Denver", state: "CO", zip: "80202", lat: 39.750833, lon: -104.996944)
      
      vendor1 = Vendor.create!(name: "Test Vendor 1", description: "A big ass market", contact_name: "Fred Mertz", contact_phone: "303.555.5521", credit_accepted: "true", market: market1)
      vendor2 = Vendor.create!(name: "Another vendor", description: "We only sell pickles", contact_name: "Marc Kucumber", contact_phone: "303.555.9999", credit_accepted: "true", market: market1)
      
      expect(market1.vendor_count).to eq(2)
      expect(market2.vendor_count).to eq(0)
    end
  end
end
