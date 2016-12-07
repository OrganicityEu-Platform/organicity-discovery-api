class V0::TypesController < ApplicationController

  def index
    @types = Asset.query_dictionary("assettypes")
    render json: @types
  end

  def show
    @types = Asset.query_dictionary("assettypes/#{params[:id]}")
    render json: @types
  end

end
