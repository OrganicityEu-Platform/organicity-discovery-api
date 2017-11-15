class InfoController < ApplicationController
  def index
    render json: {
      notice: 'Welcome to: https://discovery.organicity.eu API',
      organicity_url: 'https://organicity.eu/',
      api_documentation_url: 'https://docs.organicity.eu/api/AssetDiscovery.html',
      general_documentation_url: 'https://docs.organicity.eu/',
    }
  end
end
