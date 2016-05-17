class Api::V0::AssetsController < ApplicationController
  def index
    render json: Asset.request_entities 
  end
end
