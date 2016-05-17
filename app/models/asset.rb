class Asset < ApplicationRecord
  extend Restful
  extend Orion

  def get_assets
    return Asset.request_entities 
  end
end
