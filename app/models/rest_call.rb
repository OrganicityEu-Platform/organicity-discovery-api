class RestCall < Ohm::Model
  attribute :url
  attribute :params
  attribute :endpoint
  attribute :created_at
  attribute :response
  attribute :token

  index :url
  index :params
  index :endpoint
  index :token
end
