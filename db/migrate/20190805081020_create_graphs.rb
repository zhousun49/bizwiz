class CreateGraphs < ActiveRecord::Migration[5.2]
  def change
    create_table :graphs do |t|
      t.string :name
      t.text :style
      t.string :img_url
      t.string :category

      t.timestamps
    end
  end
end
