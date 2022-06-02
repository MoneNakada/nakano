class Item < ApplicationRecord
  
  belongs_to :genre
  has_many :cart_items, dependent: :destroy
  has_many :order_details
  
  has_one_attached :image
  
  def with_tax_price
    (price * 1.1).ceil
    # ceilは切り上げ、floorが切り捨て、roundが四捨五入
  end
end
