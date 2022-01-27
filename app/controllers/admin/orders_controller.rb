class Admin::OrdersController < ApplicationController

  def show
    @order=Order.find(params[:id])
    @order_details=OrderDetail.where(order_id: @order.id)
    @total=@order_details.inject(0) {|sum, item| sum + item.sum_of_pri}
  end

  def order_params
    params.require(:order).permit(:customer_id, :created_at, :shipping_pastal_code, :shipping_address, :shipping_name, :payment_method, :order_status)
  end
end
