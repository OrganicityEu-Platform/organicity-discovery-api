class City < ApplicationRecord
  has_many :links, as: :linkable
end
