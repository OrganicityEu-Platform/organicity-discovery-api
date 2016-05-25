class RestCall < Ohm::Model
  attribute :url
  attribute :created_at
  attribute :response

  index :url
end
