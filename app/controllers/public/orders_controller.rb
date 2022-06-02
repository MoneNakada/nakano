class Public::OrdersController < ApplicationController
  def new
    @order = Order.new
  end

  def confirm
    @cart_items = CartItem.all
    @order = Order.new(order_params)
    if params[:order][:select_address] == '0'
      @order.postal_code = current_customer.postal_code
      @order.destination = current_customer.address
      @order.name = current_customer.full_name
    elsif params[:order][:select_address] == '1'
      @address = current_customer.addresses.find(params[:order][:address_id])
      @order.postal_code = @address.postal_code
      @order.destination = @address.destination
      @order.name = @address.name
    elsif params[:order][:select_address] == '2'
      # 処理なし
    else
      render :new
    end
  end

  def create
    @order = current_customer.orders.new(order_params)
    @order.shipping_cost = 800
    @sum = 0
    
    @cart_items.each do |cart_item| 
      @sum += cart_item.subtotal 
		end
		
    @order.grand_total = @order.shipping_cost + @sum.to_i
    if @order.save
      current_customer.cart_items.each do |cart_item| #注文詳細モデルに注文商品を保存
        @order_detail = OrderDetail.new
        @order_detail.order_id = @order.id
        @order_detail.item_id = cart_item.item_id
        @order_detail.price = cart_item.subtotal
        @order_detail.amount = cart_item.amount
        @order_detail.save
      end
      current_customer.cart_items.destroy_all
      redirect_to thanks_path
    else
      render :new
    end
  end

  def thanks
  end

  def index
  end

  def show
  end

  private

  def order_params
    params.require(:order).permit(:postal_code, :destination, :name, :payment_method)
  end
end
