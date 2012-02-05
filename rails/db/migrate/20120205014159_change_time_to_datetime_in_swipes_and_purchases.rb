class ChangeTimeToDatetimeInSwipesAndPurchases < ActiveRecord::Migration
  def up
    change_column :swipes, :time, :datetime
    change_column :purchases, :time, :datetime
  end

  def down
    change_column :swipes, :time, :time
    change_column :purchases, :time, :time
  end
end
