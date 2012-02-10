class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.integer :location
      t.time    :time
      t.float  :amount

      t.integer :user_id
      t.timestamps
    end
  end
end
