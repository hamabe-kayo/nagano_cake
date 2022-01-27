class OrderDetail < ApplicationRecord
  belongs_to :item
  belongs_to :order

  enum making_status: {inpossible: 0, wait: 1, making: 2, complete: 3}
end
