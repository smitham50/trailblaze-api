class CreateJoinTableUsersTrails < ActiveRecord::Migration[6.0]
  def change
    create_join_table :users, :trails do |t|
      # t.index [:user_id, :trail_id]
      # t.index [:trail_id, :user_id]
    end
  end
end
