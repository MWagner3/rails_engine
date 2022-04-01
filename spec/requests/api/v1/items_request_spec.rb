require 'rails_helper'

describe "Items API" do
  it "sends a list of items" do
    merchant = create(:merchant)
    create_list(:item, 3, merchant_id: merchant.id)

    get '/api/v1/items'

    expect(response).to be_successful

    parsed = JSON.parse(response.body, symbolize_names: true)
    items  = parsed[:data]
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
    item     = create(:item, merchant_id: merchant.id)
    id       = item.id

    get "/api/v1/items/#{id}"

    expect(response).to be_successful

    parsed = JSON.parse(response.body, symbolize_names: true)
    item   = parsed[:data]

    expect(item[:attributes]).to have_key(:name)
    expect(item[:attributes]).to have_key(:description)
    expect(item[:attributes]).to have_key(:unit_price)
    expect(item[:attributes]).to have_key(:merchant_id)
    expect(item[:attributes][:merchant_id]).to eq(merchant.id)

  end

  it 'can create a new item' do
    merchant    = create(:merchant)
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
    item     = create(:item, merchant_id: merchant.id)
    id       = item.id

    expect(Item.count).to eq(1)

    delete "/api/v1/items/#{id}"

    expect(response).to be_successful

    expect(Item.count).to eq(0)
  end

  it 'can update an item' do

    merchant = create(:merchant)
    item     = create(:item, name: 'old thing', merchant_id: merchant.id)
    id       = item.id

    put "/api/v1/items/#{id}", params: {name: 'new thing'}
    expect(response).to be_successful
    expect(Item.last.name).to eq('new thing')

    # item.name still returns old thing??
  end

  it 'can return merchant data of an item' do

    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)
    item       = create(:item, merchant_id: merchant_1.id)
    id         = item.id

    get "/api/v1/items/#{id}/merchant"

    parsed = JSON.parse(response.body, symbolize_names: true)
    merchant = parsed[:data]

    expect(merchant[:id].to_i).to eq(merchant_1.id)
    expect(merchant[:attributes][:name]).to eq(merchant_1.name)
    expect(item.merchant_id).to eq(merchant[:id].to_i)
  end

  it 'find all items based on search' do
    merchant = Merchant.create!(name: "Test Guy")
    item_1 = Item.create!(name: "Red thing", description: "very red", unit_price: 1, merchant_id: merchant.id)
    item_2 = Item.create!(name: "Red object", description: "a bit red", unit_price: 2, merchant_id: merchant.id)
    item_3 = Item.create!(name: "Blue thing", description: "very blue", unit_price: 3, merchant_id: merchant.id)
    item_4 = Item.create!(name: "Blue object", description: "a bit blue", unit_price: 4, merchant_id: merchant.id)

    get "/api/v1/items/find_all?name=Red"

    parsed = JSON.parse(response.body, symbolize_names: true)
    items = parsed[:data]
    expect(response).to be_successful
    expect(response.status).to eq(200)

    items.each do |item|
      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes]).to have_key(:merchant_id)

      expect(item[:attributes][:name]).to_not eq(item_3.name)
      expect(item[:attributes][:name]).to_not eq(item_4.name)
    end
  end


end
