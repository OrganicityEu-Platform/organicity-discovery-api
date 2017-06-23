class MongoWorker
  include Sidekiq::Worker

  # TODO: can this be made modular?
  # This 2 vars are copied from lib/mongo_orion_client.rb
  MONGO_URL = Rails.application.secrets.mongo_url
  MONGO_PORT = Rails.application.secrets.mongo_port

  def perform(doc)
    @mongo_client = MongoClient.new(MONGO_URL, MONGO_PORT)
    apilog = @mongo_client.db('logs')
    apilog[:'logs-discovery'].insert(doc)
  end
end
