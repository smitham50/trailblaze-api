class CreateTrails < ActiveRecord::Migration[6.0]
  def change
    create_table :trails do |t|
      t.integer :trail_id
      t.string :name
      t.string :summary
      t.string :difficulty
      t.float :stars
      t.string :starVotes
      t.string :location
      t.string :url
      t.string :imgSqSmall
      t.string :imgSmall
      t.string :imgMedium
      t.float :length
      t.integer :ascent
      t.integer :descent
      t.integer :high
      t.integer :low
      t.float :longitude
      t.float :latitude
      t.string :conditionStatus
      t.string :conditionDetails
      t.datetime :conditionDate

      t.timestamps
    end
  end
end
