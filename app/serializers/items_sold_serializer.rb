# frozen_string_literal: true

class ItemsSoldSerializer
  include JSONAPI::Serializer
  attributes :name

  attribute :count, &:total_item_sold
end
