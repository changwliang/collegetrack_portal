# This migration comes from fake (originally 20160310022314)
class CreateFakeStudents < ActiveRecord::Migration
  def change
    create_table :fake_students do |t|
      t.string :race
      t.string :gender
      t.string :name
      t.string :email
      t.string :school
      t.string :year

      t.timestamps null: false
    end
  end
end
