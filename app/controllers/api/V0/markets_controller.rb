module Api 
  module V0
    class MarketsController < ApplicationController
      def index
        render json: MarketSerializer.new(Market.all)
      end

      def show
        begin
          market = Market.find(params[:id])
          render json: MarketSerializer.new(market)
        rescue ActiveRecord::RecordNotFound
          error_message = "Couldn't find Market with 'id'=#{params[:id]}"
          render json: ErrorSerializer.serialize(error_message), status: 404
        end
      end
    end
  end
end
