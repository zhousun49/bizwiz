class AddColumnToDatatables < ActiveRecord::Migration[5.2]
  def change
    rename_column :datatables, :key, :series
    add_column :datatables, :column, :string
  end
end
