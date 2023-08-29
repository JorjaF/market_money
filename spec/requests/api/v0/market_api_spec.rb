require "rails_helper"

RSpec.describe "Market API", type: :request do
  before(:each) do
      @market1 = Market.create(name: "Test Market 1", street: "123 Main St", city: "Denver", county: "Denver", state: "CO", zip: "80202", lat: 39.750833, lon: -104.996111)
    end

  describe "GET /api/v0/markets" do
    it "returns all markets" do
      vendor1 = Vendor.create!(name: "Test Vendor 1", description: "A big ass market", contact_name: "Fred Mertz", contact_phone: "303.555.5521", credit_accepted: true, market: @market1)
      
      get "/api/v0/markets"

      expect(response).to have_http_status(200)
      markets = JSON.parse(response.body)
      market1_data = markets["data"].find { |m| m["id"].to_i == @market1.id }["attributes"]
      expect(market1_data["name"]).to eq(@market1.name)
      expect(market1_data["street"]).to eq(@market1.street)
      expect(market1_data["city"]).to eq(@market1.city)
      expect(market1_data["county"]).to eq(@market1.county)
      expect(market1_data["state"]).to eq(@market1.state)
      expect(market1_data["zip"]).to eq(@market1.zip)
      expect(market1_data["lat"]).to eq(@market1.lat)
      expect(market1_data["lon"]).to eq(@market1.lon)
    end
  end
  describe "GET /api/v0/market/:id" do
    it "when a valid market id is provided" do
      vendor1 = Vendor.create!(name: "Test Vendor 1", description: "A big ass market", contact_name: "Fred Mertz", contact_phone: "303.555.5521", credit_accepted: "true", market: @market1)
      vendor2 = Vendor.create!(name: "Another vendor", description: "We only sell pickles", contact_name: "Marc Kucumber", contact_phone: "303.555.9999", credit_accepted: "true", market: @market1)

      get "/api/v0/markets/#{@market1.id}"

      expect(response).to have_http_status(200)
      json_response = JSON.parse(response.body)["data"]["attributes"]

      expect(json_response).to include(
        "name" => @market1.name,
        "street" => @market1.street,
        "city" => @market1.city,
        "county" => @market1.county,
        "state" => @market1.state,
        "zip" => @market1.zip,
        "lat" => @market1.lat,
        "lon" => @market1.lon,
        "vendor_count" => @market1.vendors.count
      )
    end

    it "gives a 404 when there is an invaild market id is input" do
      get "/api/v0/markets/invalid_id"

      expect(response).to have_http_status(404)
      
      json_response = JSON.parse(response.body)

      expect(json_response).to include(
        "error"=>"Couldn't find Market with 'id'=invalid_id"
      )
    end

  end
end