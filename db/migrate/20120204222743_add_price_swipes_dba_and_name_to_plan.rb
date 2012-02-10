class AddPriceSwipesDbaAndNameToPlan < ActiveRecord::Migration
  def change
    add_column :plans, :price, :float

    add_column :plans, :swipes, :integer

    add_column :plans, :dba, :float

    add_column :plans, :name, :string

  end
end
