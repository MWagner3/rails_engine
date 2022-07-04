# frozen_string_literal: true

module Api
  module V1
    module Revenue
      class MerchantsController < ApplicationController
        def index
          number = params[:quantity]
          merchants = Merchant.top_merchants_by_revenue(number)
          render json: MerchantNameRevenueSerializer.new(merchants)
        end
      end
    end
  end
end
