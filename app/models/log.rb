class Log < Ohm::Model
  attribute :url
  attribute :params
  attribute :endpoint
  attribute :created_at
  attribute :response

  index :url
  index :params
  index :endpoint

  # Include Mongo Orion Client
  # Send to mongo via Resque
  
end
