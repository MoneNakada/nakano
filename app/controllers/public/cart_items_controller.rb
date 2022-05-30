class Public::CartItemsController < ApplicationController
  def index
    @cart_items = CartItem.all
  end

  def create
    @item = Item.find(params[:item_id])
    @cart_item = current_customer.cart_items.find_by(item_id: @item.id)
    if @cart_item.present?
      new_amount = @cart_item.amount + cart_item_params[:amount].to_i
      @cart_item.update(amount: new_amount)
      redirect_to cart_items_path
    else
      @cart_item = current_customer.cart_items.new(cart_item_params)
      @cart_item.item_id = @item.id
      if @cart_item.save
        redirect_to cart_items_path
      else
        render 'public/items/show'
      end
    end
  end

  def update
    @item = Item.find(params[:item_id])
    @cart_item = current_customer.cart_items.find_by(item_id: @item.id)
    @cart_item.update(cart_item_params)
    redirect_to cart_items_path
  end

  def destroy
    @item = Item.find(params[:item_id])
    @cart_item = current_customer.cart_items.find_by(item_id: @item.id)
    @cart_item.destroy
    redirect_to cart_items_path
  end

  def destroy_all
    CartItem.destroy_all
    redirect_to cart_items_path
  end

  private
  def cart_item_params
    params.require(:cart_item).permit(:amount)
  end
end
