require 'rails_helper'

describe "Merchants API" do
  it "sends a list of merchants" do
    create_list(:merchant, 3)

    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants[:data].count).to eq(3)

    merchants[:data].each do |merchant|

      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_a(String)

      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_a(String)
    end
  end

  it "can get one merchant by its id" do
    id = create(:merchant).id

    get "/api/v1/merchants/#{id}"

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful

    expect(merchant[:data]).to have_key(:id)
    expect(merchant[:data][:id]).to be_a(String)
    expect(merchant[:data][:attributes]).to have_key(:name)
    expect(merchant[:data][:attributes][:name]).to be_a(String)
  end

  it 'can return all merchant items' do
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)
    item_1 = create :item, { merchant_id: merchant_1.id }
    item_2 = create :item, { merchant_id: merchant_1.id }
    item_3 = create :item, { merchant_id: merchant_2.id }

    get "/api/v1/merchants/#{merchant_1.id}/items"

    parsed = JSON.parse(response.body, symbolize_names: true)
    items = parsed[:data]
    expect(response).to be_successful
    expect(merchant_1.items.count).to eq(2)

    items.each do |item|
      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes]).to have_key(:merchant_id)
      expect(item[:attributes][:merchant_id]).to eq(merchant_1.id)
    end
  end

  it 'find merchant based on search' do
    merchant = Merchant.create!(name: "Test Guy")
    merchant = Merchant.create!(name: "Test Man")
    merchant = Merchant.create!(name: "Test Fellow")
    merchant = Merchant.create!(name: "Test Chum")

    get "/api/v1/merchants/find?name=Guy"

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(response.status).to eq(200)
    expect(merchant[:data][:attributes]).to have_key(:name)
    expect(merchant[:data][:attributes][:name]).to eq("Test Guy")

    get "/api/v1/merchants/find?name=Lad"

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(response.status).to eq(404)
    expect(merchant[:data][:message]).to eq("Merchant not found")
  end
end
