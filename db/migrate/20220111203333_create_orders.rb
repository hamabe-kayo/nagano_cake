class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|

      t.integer :customers_id
      t.string :shipping_pastal_code
      t.string :shipping_address
      t.string :shipping_name
      t.integer :postage
      t.integer :payment_method, default: 0, null: false, limit: 2
      t.integer :paymaent
      t.integer :order_status, default: 0, null: false, limit:5
      t.datetime :created_at
      t.datetime :updated_at

      t.timestamps
    end
  end
end