class V0::TypesController < ApplicationController

  def index
    @types = JSON.parse(Asset.query_dictionary("assettypes"))
    render json: @types
  end

  def show
    @type = Asset.query_dictionary("assettypes/#{params[:id]}")
    if @type.to_s == ""
      render json: {error: {status: 404, message: 'Not found'}}
    else
      render json: JSON.parse(@type)
    end
  end

end
