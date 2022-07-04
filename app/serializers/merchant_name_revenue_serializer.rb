# frozen_string_literal: true

class MerchantNameRevenueSerializer
  include JSONAPI::Serializer
  attributes :name

  attribute :revenue, &:total_revenue
end
