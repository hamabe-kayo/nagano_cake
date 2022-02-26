class Admin::HomesController < ApplicationController

  def top
    @orders=Order.all
  end

  private
  def order_detail_params
    params.repuire(:order_detail).permit(:order_id, :item_id, :order_price, :amount, :making_status)
  end

end
