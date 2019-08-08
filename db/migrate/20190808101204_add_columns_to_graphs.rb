class AddColumnsToGraphs < ActiveRecord::Migration[5.2]
  def change
    add_column :graphs, :x_axis_title, :string
    add_column :graphs, :y_axis_title, :string
    add_column :graphs, :legend, :boolean, default: true
  end
end
