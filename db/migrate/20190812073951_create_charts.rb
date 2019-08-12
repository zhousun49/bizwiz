class CreateCharts < ActiveRecord::Migration[5.2]
  def change
    create_table :charts do |t|
      t.references :graph, foreign_key: true
      t.string :name
      t.string :category
      t.text :style
      t.string :img_url
      t.string :x_axis_title
      t.string :y_axis_title
      t.boolean :legend, default: true

      t.timestamps
    end
  end
end
