class Graph < ApplicationRecord
  has_many :datatables, dependent: :destroy
<<<<<<< HEAD
  has_many :charts, dependent: :destroy
=======
  belongs_to :collection
>>>>>>> c198fac345312c43fba83458a97ddd060117db0f
end
