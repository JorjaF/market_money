module Api 
  module V0
    class VendorsController < ApplicationController
      def index
        render json: VendorSerializer.new(Vendor.all)
      end
    end
  end
end
