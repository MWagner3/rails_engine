# frozen_string_literal: true

class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :customers, through: :invoices
  has_many :invoices, through: :invoice_items
end
