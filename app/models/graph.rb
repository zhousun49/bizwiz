class Graph < ApplicationRecord
  has_many :datatables, dependent: :destroy
end
