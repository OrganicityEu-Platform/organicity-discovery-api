class Api::V0::AssetsController < ApplicationController
  def index
    render json: Asset.get_assets, each_serializer: AssetSerializer, root: false
  end
end
