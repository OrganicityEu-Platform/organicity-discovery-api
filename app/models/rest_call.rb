class RestCall < Ohm::Model
  attribute :url
  attribute :params
  attribute :endpoints
  attribute :created_at
  attribute :response

  index :url
  index :params
  index :endpoints
end
