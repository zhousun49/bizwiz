class ChangeValueToStringInDatatables < ActiveRecord::Migration[5.2]
  def change
    change_column :datatables, :value, :string
  end
end
