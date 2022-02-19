class Public::OrdersController < ApplicationController
  before_action :authenticate_customer!

  def new
    @order=Order.new
    @order.customers_id=current_customer.id
    @shipping_addresses=ShippingAddress.all
  end

  def log
    @order = Order.new(order_params)
    @order.customers_id=current_customer.id
    @cart_items=CartItem.all
    @total=@cart_items.inject(0) { |sum, item| sum + item.subtotal }
    @payment=(@total + 800).to_s

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
    # binding.pry

    @order=Order.new(order_params)
    @order.customers_id=current_customer.id
    @cart_items=current_customer.cart_items.all

    if @order.save
      @cart_items.each do |cart_item|
        @order_detail=OrderDetail.new
        @order_detail.order_id=@order.id
        @order_detail.item_id=cart_item.item.id
        @order_detail.order_price=cart_item.item.with_tax_price
        @order_detail.amount=cart_item.amount
        @order_detail.making_status=0
        @order_detail.save
      end
      @cart_items.destroy_all
      redirect_to thanks_orders_path
    else
      redirect_to new_order_path
    end
  end

  def index
    @orders=OrderDetail.all
  end

  def show
  end

  private
  def order_params
    params.require(:order).permit(:customers_id, :shipping_postal_code, :shipping_address, :shipping_name, :payment_method, :payment)
  end

end
