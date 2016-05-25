class RestCall < Ohm::Model
  attribute :url
  attribute :created_at
  attribute :response
  collection :entities, :Entity

  index :url
end
