# frozen_string_literal: true

module Api
  module V1
    class MerchantsController < ApplicationController
      def index
        render json: MerchantSerializer.new(Merchant.all)
      end

      def show
        render json: MerchantSerializer.new(Merchant.find(params[:id]))
      end

      def find
        merchant = Merchant.where('name ILIKE ?', "%#{params[:name]}%").first
        if merchant.nil?
          render json: { data: { message: 'Merchant not found' } }, status: 404
        else
          render json: MerchantSerializer.new(merchant)
        end
      end

      def most_items
        if params[:quantity].nil?
          render json: JSON.generate({ error: 'error' }), status: 400
        else
          number = params[:quantity]
          merchant = Merchant.item_revenue(number)
          render json: ItemsSoldSerializer.new(merchant)
        end
      end
    end
  end
end
