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
  
  describe "POST /api/v0/vendors" do
    context "add a vendor with valid attributes" do
      let(:valid_attributes) do
        {
          name: "Isis Books and Gifts",
          description: "Metaphysical books, gifts, and supplies",
          contact_name: "Nancy Harrison",
          contact_phone: "303-761-8627",
          credit_accepted: false,
          market_id: @market1.id
        }
      end
      
      it "creates a new vendor" do
        post "/api/v0/vendors", params: { vendor: valid_attributes }

        expect(response).to have_http_status(201)
        
        json_response = JSON.parse(response.body)["data"]["attributes"]

        expect(json_response["name"]).to eq(valid_attributes[:name])
        expect(json_response["description"]).to eq(valid_attributes[:description])
        expect(json_response["contact_name"]).to eq(valid_attributes[:contact_name])
        expect(json_response["contact_phone"]).to eq(valid_attributes[:contact_phone])
        expect(json_response["credit_accepted"]).to eq(valid_attributes[:credit_accepted])
      end
    end

    context "trying to create a vendor with invalid attributes" do
      let(:invalid_attributes) do
        {
          name: "Spirit Ways",
          description: "Metaphysical books, gifts, and supplies",
          contact_name: "Amy Smith",
          contact_phone: "303-761-8627",
          market_id: @market1.id
        }
      end

      it "returns a 400 status with descriptive error message" do
        post "/api/v0/vendors", params: { vendor: invalid_attributes }

        expect(response).to have_http_status(400)
        json_response = JSON.parse(response.body)

        expect(json_response).to include(
          "error"=> {"credit_accepted"=>["must be true or false"]}
        )
      end
    end
  end

  describe "DELETE /api/v0/vendors/:id" do
    context "when a valid vendor id is provided" do
      let!(:vendor) { Vendor.create!(name: "Isis Books and Gifts", description: "Metaphysical books, gifts, and supplies", contact_name: "Nancy Harrison", contact_phone: "303-761-8627", credit_accepted: false, market: @market1) }

      it "can delete a vendor and its associations" do
        expect{
          delete "/api/v0/vendors/#{vendor.id}"
      }.to change(Vendor, :count).by(-1)
        expect(response).to have_http_status(204)
        expect(response.body).to be_empty
      end
    end

    context "when an invalid vendor id is provided" do
      it "returns a 404 status" do
        delete "/api/v0/vendors/invalid_id"
        
        expect(response).to have_http_status(404)
      end
    end
  end
end
