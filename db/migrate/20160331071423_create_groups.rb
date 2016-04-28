class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.timestamps null: false
      t.string :name
      t.string :filters #separated by whatever
      t.belongs_to :user, index: true
      t.string :extra_emails
    end
  end
end
