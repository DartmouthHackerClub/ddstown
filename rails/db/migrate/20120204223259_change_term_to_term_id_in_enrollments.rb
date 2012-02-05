class ChangeTermToTermIdInEnrollments < ActiveRecord::Migration
  def up
    add_column :enrollments, :term_id, :int
    remove_column :enrollments, :term
  end

  def down
    add_column :enrollments, :term, :string
    remove_column :enrollments, :term_id
  end
end
