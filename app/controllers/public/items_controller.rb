class Public::ItemsController < ApplicationController
  before_action :authenticate_customer!, except: [:index, :show]

  def index
    @items=Item.all.order(id: :desc).page(params[:page]).per(8).reverse_order
  end

  def show
    @item=Item.find(params[:id])
    @cart_item=CartItem.new
    @cart_item.item_id=@item.id
  end

  private
  def item_params
    params.require(:item).permit(:genre_id, :name, :image, :introduction, :price, :is_active, :created_at, :updated_at)
  end

end
