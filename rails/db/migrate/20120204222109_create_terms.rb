class CreateTerms < ActiveRecord::Migration
  def change
    create_table :terms do |t|
      t.date :start
      t.date :end
      t.integer :year
      t.string :term

      t.timestamps
    end
  end
end
