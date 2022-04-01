class Api::V1::ItemsController < ApplicationController

  def index
    render json: ItemSerializer.new(Item.all)
  end

  def show
    render json: ItemSerializer.new(Item.find(params[:id]))
  end

  def create
    render json: ItemSerializer.new(Item.create(item_params)), status: 201
  end

  def destroy
    item = Item.find(params[:id])
    item.destroy
  end

  def update
    item = Item.find(params[:id])
    if item.update(item_params)
      render json: ItemSerializer.new(item)
    else
      render status: 404
    end
  end

  def find_all
    items = Item.where("name ILIKE ?", "%#{params[:name]}%")
    render json: ItemSerializer.new(items)
  end


  private

  def item_params
    params.permit(:name, :description, :unit_price, :merchant_id)
  end
end
