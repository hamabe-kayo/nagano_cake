class Public::OrdersController < ApplicationController
  before_action :authenticate_customer!

  def new
    @order=Order.new
    @order.customer_id=current_customer.id
    @shipping_addresses=ShippingAddress.all
  end

  def log
    @order = Order.new(order_params)
    @order.customer_id=current_customer.id
    @cart_items=CartItem.all
    @payment=@cart_items.inject(0) { |sum, item| sum + item.subtotal }
    @total=(@payment + 800).to_s

    if params[:order][:select_address] == "0"
      @order.shipping_postal_code=current_customer.postal_code
      @order.shipping_address=current_customer.address
      @order.shipping_name=current_customer.full_name
    elsif params[:order][:select_address] == "1"
      @order.shipping_postal_code=ShippingAddress.find(params[:order][:shipping_address_id]).postal_code
      @order.shipping_address=ShippingAddress.find(params[:order][:shipping_address_id]).address
      @order.shipping_name=ShippingAddress.find(params[:order][:shipping_address_id]).name
    elsif params[:order][:select_address] == "2"
      @order.shipping_postal_code=order_params[:shipping_postal_code]
      @order.shipping_address=order_params[:shipping_address]
      @order.shipping_name=order_params[:shipping_name]
    end

  end

  def thanks
  end

  def create

    @order=Order.new(order_params)
    @order.customer_id=current_customer.id
    @order.save

    current_customer.cart_items.each do |cart_item|
      @order_detail=OrderDetail.new
      @order_detail.order_id=@order.id
      @order_detail.item_id=cart_item.item_id
      @order_detail.order_price=cart_item.item.with_tax_price
      @order_detail.amount=cart_item.amount
      @order_detail.making_status=0
      @order_detail.save
    end
    current_customer.cart_items.destroy_all
    redirect_to thanks_orders_path
  end


  def index
    @orders=Order.page(params[:page]).reverse_order
  end

  def show
    @order=Order.find(params[:id])
    @postage=800
  end

  private
  def order_params
    params.require(:order).permit(:customer_id, :shipping_postal_code, :shipping_address, :shipping_name, :payment_method)
  end
  def order_detail_params
    params.repuire(:order_detail).permit(:order_id, :item_id, :order_price, :amount, :making_status)
  end
end
