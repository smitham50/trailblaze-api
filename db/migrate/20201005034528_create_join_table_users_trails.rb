class CreateJoinTableUsersTrails < ActiveRecord::Migration[6.0]
  def change
    create_join_table :users, :trails do |t|
    end
  end
end
