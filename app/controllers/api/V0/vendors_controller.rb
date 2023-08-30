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
          render json: { error: "Couldn't find Vendor with 'id'=#{params[:id]}" }, status: 404
        end
      end
    end
  end
end
