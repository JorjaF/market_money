require "rails_helper"

RSpec.describe "Market API", type: :request do
  before(:each) do
      @market1 = Market.create!(name: "Organic Market", street: "123 Main St", city: "Denver", county: "Denver", state: "CO", zip: "80202", lat: 39.750833, lon: -104.996111)
      @market2 = Market.create!(name: "Simon Whistler Market", street: "456 Main St", city: "Denver", county: "Denver", state: "CO", zip: "80202", lat: 39.750833, lon: -104.996111)
      @vendor1 = Vendor.create!(name: "Desilu", description: "A big ass market", contact_name: "Fred Mertz", contact_phone: "3031725521", credit_accepted: true, market: @market1)
      @vendor2 = Vendor.create!(name: "A Raw Dill", description: "We only sell pickles", contact_name: "Marc Kucumber", contact_phone: "303-555-9999", credit_accepted: "true", market: @market1)
      @vendor3 = Vendor.create!(name: "Chicken Feet", description: "Premium chicken parts for magical use!", contact_name: "Marie Laveau", contact_phone: "504.279.3812", credit_accepted: "true", market: @market1)
    end

  describe "GET /api/v0/markets" do
    it "returns all markets" do
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

      market2_data = markets["data"].find { |m| m["id"].to_i == @market2.id }["attributes"]
      expect(market2_data["name"]).to eq(@market2.name)
    end
  end

  describe "GET /api/v0/market/:id" do
    it "when a valid market id is provided it returns the market information" do
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
  
  describe "GET /api/v0/markets/:id/vendors" do
    it "returns all vendors for a given market" do
      
      get "/api/v0/markets/#{@market1.id}/vendors"

      expect(response).to have_http_status(200)
      vendors = JSON.parse(response.body)["data"]

      expect(vendors).to be_an(Array)
      expect(vendors.count).to eq(3)

      vendor1_data = vendors.find { |v| v["id"].to_i == @vendor1.id }
      expect(vendor1_data).to include(
        "id" => @vendor1.id.to_s,
        "attributes" => {
          "name" => @vendor1.name,
          "description" => @vendor1.description,
          "contact_name" => @vendor1.contact_name,
          "contact_phone" => @vendor1.contact_phone,
          "credit_accepted" => @vendor1.credit_accepted,
          "market_id" => @vendor1.market_id
        })

      vendor2_data = vendors.find { |v| v["id"].to_i == @vendor2.id }
      expect(vendor2_data).to include(
        "id" => @vendor2.id.to_s,
        "attributes" => {
          "name" => @vendor2.name,
          "description" => @vendor2.description,
          "contact_name" => @vendor2.contact_name,
          "contact_phone" => @vendor2.contact_phone,
          "credit_accepted" => @vendor2.credit_accepted,
          "market_id" => @vendor2.market_id
        }) 
        
      vendor3_data = vendors.find { |v| v["id"].to_i == @vendor3.id }
      expect(vendor3_data).to include(
        "id" => @vendor3.id.to_s,
        "attributes" => {
          "name" => @vendor3.name,
          "description" => @vendor3.description,
          "contact_name" => @vendor3.contact_name,
          "contact_phone" => @vendor3.contact_phone,
          "credit_accepted" => @vendor3.credit_accepted,
          "market_id" => @vendor3.market_id
        })
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
