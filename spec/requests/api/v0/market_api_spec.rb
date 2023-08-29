require "rails_helper"

RSpec.describe "Market API", type: :request do
  describe "GET /api/v0/markets" do
    it "returns all markets" do
      market1 = Market.create!(name: "Test Market 1", street: "123 Main St", city: "Denver", county: "Denver", state: "CO", zip: "80202", lat: 39.750833, lon: -104.996944)
      
      vendor1 = Vendor.create!(name: "Test Vendor 1", description: "A big ass market", contact_name: "Fred Mertz", contact_phone: "303.555.5521", credit_accepted: true, market: market1)
      
      get "/api/v0/markets"

      expect(response).to have_http_status(200)
      markets = JSON.parse(response.body)

      market1_data = markets.find { |m| m["id"] == market1.id }
      expect(market1_data["name"]).to eq(market1.name)
      expect(market1_data["street"]).to eq(market1.street)
      expect(market1_data["city"]).to eq(market1.city)
      expect(market1_data["county"]).to eq(market1.county)
      expect(market1_data["state"]).to eq(market1.state)
      expect(market1_data["zip"]).to eq(market1.zip)
      expect(market1_data["lat"]).to eq(market1.lat)
      expect(market1_data["lon"]).to eq(market1.lon)
    end
  end
end
