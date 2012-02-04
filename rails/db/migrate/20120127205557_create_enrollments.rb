class CreateEnrollments < ActiveRecord::Migration
  def change
    create_table :enrollments do |t|
      t.integer :user_id
      t.integer :plan_id

      t.string  :term
      t.timestamps
    end
  end
end
