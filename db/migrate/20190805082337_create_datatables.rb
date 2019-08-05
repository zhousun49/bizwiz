class CreateDatatables < ActiveRecord::Migration[5.2]
  def change
    create_table :datatables do |t|
      t.float :value
      t.string :key
      t.references :graph, foreign_key: true

      t.timestamps
    end
  end
end
