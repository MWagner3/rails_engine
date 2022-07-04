# frozen_string_literal: true

class Transaction < ApplicationRecord
  belongs_to :invoice
  has_many :invoice_items, through: :invoice
end
