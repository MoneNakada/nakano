class Public::CustomersController < ApplicationController
  def show
    @customer = current_customer
  end

  def edit
    @customer = current_customer
  end

  def update
    if @customer = Customer.update(customer_params)
      redirect_to mypage_path
    else
      render :edit
    end
  end
  
  def unsubscribe
  end  

  private
  def customer_params
    params.require(:customer).permit(:last_name, :first_name, :first_name_kana, :last_name_kana, :email, :postal_code, :address, :telephone_number)
  end
end