class CreateSwipes < ActiveRecord::Migration
  def change
    create_table :swipes do |t|
      t.string :location
      t.time   :time
      
      t.integer :user_id

      t.timestamps
    end
  end
end
