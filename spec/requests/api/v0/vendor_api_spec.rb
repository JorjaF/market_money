require "rails_helper"

RSpec.describe "Vendor API", type: :request do
  before(:each) do
      @market1 = Market.create!(name: "Organic Market", street: "123 Main St", city: "Denver", county: "Denver", state: "CO", zip: "80202", lat: 39.750833, lon: -104.996111)
      @market2 = Market.create!(name: "Simon Whistler Market", street: "456 Main St", city: "Denver", county: "Denver", state: "CO", zip: "80202", lat: 39.750833, lon: -104.996111)
      @vendor1 = Vendor.create!(name: "Desilu", description: "A big ass market", contact_name: "Fred Mertz", contact_phone: "3031725521", credit_accepted: true, market: @market1)
      @vendor2 = Vendor.create!(name: "A Raw Dill", description: "We only sell pickles", contact_name: "Marc Kucumber", contact_phone: "303-555-9999", credit_accepted: "true", market: @market1)
      @vendor3 = Vendor.create!(name: "Chicken Feet", description: "Premium chicken parts for magical use!", contact_name: "Marie Laveau", contact_phone: "504.279.3812", credit_accepted: "true", market: @market1)
  end

  describe "GET /api/v0/vendors/:id" do
    it "when a valid vendor id is provided it returns that vendor's information" do
      get "/api/v0/vendors/#{@vendor1.id}"

      expect(response).to have_http_status(200)
      json_response = JSON.parse(response.body)["data"]["attributes"]

      expect(json_response).to include(
        "name" => @vendor1.name,
        "description" => @vendor1.description,
        "contact_name" => @vendor1.contact_name,
        "contact_phone" => @vendor1.contact_phone,
        "credit_accepted" => @vendor1.credit_accepted
      )

      get "/api/v0/vendors/#{@vendor2.id}"

      expect(response).to have_http_status(200)
      json_response = JSON.parse(response.body)["data"]["attributes"]

      expect(json_response).to include(
        "name" => @vendor2.name,
        "description" => @vendor2.description,
        "contact_name" => @vendor2.contact_name,
        "contact_phone" => @vendor2.contact_phone,
        "credit_accepted" => @vendor2.credit_accepted
      )
    end

    it "gives a 404 when there is an invaild market id is input" do
      get "/api/v0/vendors/invalid_id"

      expect(response).to have_http_status(404)
      
      json_response = JSON.parse(response.body)

      expect(json_response).to include(
        "error"=>"Couldn't find Vendor with 'id'=invalid_id"
      )
    end
  end
end
