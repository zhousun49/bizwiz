class Graph < ApplicationRecord
  has_many :datatables, dependent: :destroy
  has_many :charts, dependent: :destroy
end
