class CreateUserHikes < ActiveRecord::Migration[6.0]
  def change
    create_table :user_hikes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :trail, null: false, foreign_key: true
    end
  end
end
