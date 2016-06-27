class Discovery::V0::SitesController < ApplicationController
  def index
    @sites = City.all.includes(:links)
    render json: @sites, each_serializer: SiteSerializer, root: false
  end
end
