class CreateUserTrails < ActiveRecord::Migration[6.0]
  def change
    create_table :user_trails do |t|
      t.integer :user_id
      t.integer :trail_id
    end
  end
end
