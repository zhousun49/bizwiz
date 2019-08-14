class Graph < ApplicationRecord
  has_many :datatables, dependent: :destroy
  belongs_to :collection

  def to_param
    slug
  end
end
