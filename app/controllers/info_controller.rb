class InfoController < ApplicationController
  def index
    render plain: 'Welcome to: https://discovery.organicity.eu'
  end
end
