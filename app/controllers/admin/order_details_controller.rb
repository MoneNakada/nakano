class Admin::OrderDetailsController < ApplicationController
  
  def update
    @order = Order.find(params[:order_id])
    @order_detail = @order.order_details.find(params[:id])
    @order_detail.update(order_detail_params) 
    if @order_detail.making_status == "in_production"
      @order.update(status: 2)
    elsif @order.order_details.completed.count == @order.order_details.count
      @order.update(status: 3)
    end
    redirect_to admin_order_path(@order)
  end

  private

  def order_detail_params
    params.require(:order_detail).permit(:making_status)
  end
  
end
