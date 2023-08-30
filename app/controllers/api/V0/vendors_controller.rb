module Api 
  module V0
    class VendorsController < ApplicationController
      def index
        render json: VendorSerializer.new(Vendor.all)
      end

      def show
        begin
          vendor = Vendor.find(params[:id])
          render json: VendorSerializer.new(vendor)
        rescue ActiveRecord::RecordNotFound
          render json: ErrorSerializer.serialize("Couldn't find Vendor with 'id'=#{params[:id]}"), status: 404
        end
      end

      def create
        vendor = Vendor.new(vendor_params)
        if vendor.save
          render json: VendorSerializer.new(vendor), status: 201
        else
          render json: ErrorSerializer.serialize(vendor.errors.messages), status: 400
        end
      end

      private

      def vendor_params
        params.require(:vendor).permit(:name, :description, :contact_name, :contact_phone, :credit_accepted, :market_id)
      end
    end
  end
end
