class Admin::OrdersController < ApplicationController

  def show
    @order=Order.find(params[:id])
    @postage=800
  end
  def order_params
    params.require(:order).permit(:customer_id, :created_at, :shipping_pastal_code, :shipping_address, :shipping_name, :payment_method, :order_status)
  end
end
