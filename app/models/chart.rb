class Chart < ApplicationRecord
  belongs_to :graph
  has_many :datatables, through: :graphs
end
