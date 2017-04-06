class GeoCacheWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

# TODO: Eats up memory.
#  recurrence { hourly.minute_of_hour(0, 10, 20, 30, 40, 50) }
#
#  def perform()
#    logger.warn "[Sidekiq] Performing geo cache"
#    Asset.get_mongo_assets({}, "mongo_geo_assets")
#  end
end
