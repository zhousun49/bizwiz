class AddSlugToGraphs < ActiveRecord::Migration[5.2]
  def change
    add_column :graphs, :slug, :string, null: false
    add_index :graphs, :slug, unique: true
  end
end
