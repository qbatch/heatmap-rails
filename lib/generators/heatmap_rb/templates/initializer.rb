class CreateHeatMaps < ActiveRecord::Migration[5.1]
  def change
    create_table :heat_maps do |t|
      t.string :path
      t.integer :x_coordinate
      t.integer :y_coordinate
      t.string :click_type

      t.timestamps
    end
  end
end
