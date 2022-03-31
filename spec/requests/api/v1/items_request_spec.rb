require 'rails_helper'

describe "Items API" do
  it "sends a list of items" do
    merchant = create(:merchant)
    create_list(:item, 3, merchant_id: merchant.id)

    get '/api/v1/items'

    expect(response).to be_successful

    parsed = JSON.parse(response.body, symbolize_names: true)
    items = parsed[:data]
    expect(items.count).to eq(3)

    items.each do |item|
      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes]).to have_key(:merchant_id)
      expect(item[:attributes][:merchant_id]).to eq(merchant.id)
    end
  end

  it "finds an item by ID" do
    merchant = create(:merchant)
    item = create(:item, merchant_id: merchant.id)
    id = item.id

    get "/api/v1/items/#{id}"

    expect(response).to be_successful

    parsed = JSON.parse(response.body, symbolize_names: true)
    item = parsed[:data]

    expect(item[:attributes]).to have_key(:name)
    expect(item[:attributes]).to have_key(:description)
    expect(item[:attributes]).to have_key(:unit_price)
    expect(item[:attributes]).to have_key(:merchant_id)
    expect(item[:attributes][:merchant_id]).to eq(merchant.id)

  end

  it 'can create a new item' do
    merchant = create(:merchant)
    item_params = { name: 'Thing 1', unit_price: 5, description: 'the first thing', merchant_id: merchant.id}

    post "/api/v1/items", params: item_params
    expect(response).to be_successful

    item = Item.last
    expect(item.name).to eq 'Thing 1'
    expect(item.unit_price).to eq 5
    expect(item.description).to eq 'the first thing'
    expect(item.merchant_id).to eq merchant.id
  end

  it 'can delete an item' do
    merchant = create(:merchant)
    item = create(:item, merchant_id: merchant.id)
    id = item.id

    expect(Item.count).to eq(1)

    delete "/api/v1/items/#{id}"

    expect(response).to be_successful

    expect(Item.count).to eq(0)
  end

  
end
