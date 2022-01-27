class Public::CartItemsController < ApplicationController
  before_action :authenticate_customer!

  def index
    @cart_items=current_customer.cart_items
  end

  def update

  end

  def destroy
  end

  def destroy_all
  end

  def create
    if Item.find_by(item: item_)
  end

  private
  def cart_item_params
    params.permit(:item_id, :amount, :customer_id)
  end
end
