class Merchant < ApplicationRecord
   has_many :items
   has_many :invoices
   has_many :transactions, through: :invoices
   has_many :customers, through: :invoices
   has_many :invoice_items, through: :invoices


  def self.top_merchants_by_revenue(number)
    joins(invoices: { invoice_items: :transactions })
    .where(transactions: { result: 'success' }, invoices: {status: 'shipped'})
    .group('merchants.id')
    .select("merchants.*, SUM(invoice_items.quantity * invoice_items.unit_price) as total_revenue")
    .order(total_revenue: :desc)
    .limit(number)
  end

  def self.item_revenue(number)
    joins(invoices: {invoice_items: :transactions})
    .where(transactions: { result: "success"}, invoices: { status: 'shipped'})
    .select("merchants.*, SUM(invoice_items.quantity)as total_item_sold")
    .group(:id)
    .order(total_item_sold: :desc)
    .limit(number)
  end
end
