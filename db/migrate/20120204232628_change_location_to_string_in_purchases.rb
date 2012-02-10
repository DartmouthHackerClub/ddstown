class ChangeLocationToStringInPurchases < ActiveRecord::Migration
  def up
    change_column :purchases, :location, :string
  end

  def down
    change_column :purchases, :location, :integer
  end
end
