class Public::OrdersController < ApplicationController
  before_action :authenticate_customer!

  def new
    @order=Order.new
    @shipping_addresses=ShippingAddress.all
  end

  def log
    @order = Order.new(order_params)
    # @shipping_address=ShippingAddress.find(params[:order][:shipping_address_id])


    if params[:order][:select_address] == "0"
      @order.shipping_postal_code=current_customer.postal_code
      @order.shipping_address=current_customer.address
      @order.shipping_name=current_customer.full_name
    elsif params[:order][:select_address] == "1"
      @order.shipping_postal_code=ShippingAddress.find(params[:order][:shipping_address_id]).postal_code
      @order.shipping_address=ShippingAddress.find(params[:order][:shipping_address_id]).address
      @order.shipping_name=ShippingAddress.find(params[:order][:shipping_address_id]).name
    else
      @order.shipping_postal_code=order_params[:shipping_postal_code]
      @order.shipping_address=order_params[:shipping_address]
      @order.shipping_name=order_params[:shipping_name]
    end

    @cart_items=current_customer.cart_items.all
    @total=@cart_items.inject(0) { |sum, item| sum + item.subtotal }
  end

  def thanks
  end

  def create
    @order=Order.new(order_params)
    @cart_items=current_customer.cart_items.all

    if @order.save
      @cart_items.each do |cart_item|
        order_detail=OrderDetail.new
        order_detail.item_id=cart_item.item_id
        order_detail.order_id=@order.id
        order_detail.order_amount=cart_item.amount
        order_detail.order_price=cart_item.sutotal
        order_detail.save
      end
      redirect_to thanks_orders_path
      cart_items.destroy_all
    else
      @order=Order.new(order_params)
      render :new
    end
    
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
    else
      render :new
    end
    redirect_to thanks_orders_path

    # binding.pry
  end

  def index
  end

  def show
  end

  private
  def order_params
    params.require(:order).permit(:customers_id, :shipping_postal_code, :shipping_address, :shipping_name, :payment_method)
  end

end
