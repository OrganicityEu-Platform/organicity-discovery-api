class V0::TypesController < ApplicationController

  def index
    @types = JSON.parse(Asset.query_dictionary("assettypes"))
    render json: @types
  end

  def show
    @types = JSON.parse(Asset.query_dictionary("assettypes/#{params[:id]}"))
    render json: @types
  end

end
