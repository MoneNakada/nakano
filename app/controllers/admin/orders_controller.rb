class Admin::OrdersController < ApplicationController
  
  def index
    @orders = Order.all
  end
  
  def show
    @order = Order.find(params[:id])
    @order_details = @order.order_details.all
    @customer = @order.customer
  end
  
  def update
    @order = Order.find(params[:id])
    @order.update(order_params)
    if @order.status == "confirm_deposit"
      @order.order_details.update_all(making_status: 1)
    end
    redirect_to admin_order_path(@order)
  end
  
  private

  def order_params
    params.require(:order).permit(:status)
  end
end
