class RestCall < Ohm::Model
  attribute :url
  attribute :params
  attribute :endpoint
  attribute :created_at
  attribute :response

  index :url
  index :params
  index :endpoint
end
