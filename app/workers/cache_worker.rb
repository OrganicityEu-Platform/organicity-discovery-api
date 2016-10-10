class CacheWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { hourly.minute_of_hour(0, 10, 20, 30, 40, 50) }

  def perform(query_params = {})
    logger.warn "[Sidekiq] Performing types cache"
    Asset.query_dictionary("assettypes")
  end
end
