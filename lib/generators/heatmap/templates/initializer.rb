class CreateHeatMaps < ActiveRecord::Migration[5.1]
  def change
    create_table :heat_maps do |t|
      t.string :path
      t.float :x_coordinate
      t.float :y_coordinate
      t.string :click_type

      t.timestamps
    end
  end
end
