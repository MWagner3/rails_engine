# frozen_string_literal: true

module Api
  module V1
    class MerchantItemsController < ApplicationController
      def index
        merchant = Merchant.find(params[:merchant_id])
        render json: ItemSerializer.new(merchant.items)
      end

      def show
        item = Item.find(params[:item_id])
        render json: MerchantSerializer.new(Merchant.find(item.merchant_id))
      end
    end
  end
end
