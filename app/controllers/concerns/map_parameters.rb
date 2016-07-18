module MapParameters
  extend ActiveSupport::Concern

  #
  # Map request parameters into a query like string
  # Params:
  # last_updated - Filter assets by last updated date
  # type         - Filter assets by type
  # sort         - Sort assets. Supported values are to be defined.
  # filter       - Filter assets. Supported values are to be defined.
  # order        - Order assets DESC or ASC.
  # offset       - Return assets with the given offset of N results.
  # page         - Return assets for the given page.
  # per          - Return N assets per page.
  # sample       - Return a random sample of N assets.
  # query        - Return a list of assets based on metadatadatatata search
  def map_query_parameters(params)
    allowed_parameters = [
      :id,
      :type,
      :sort,
      :filter,
      :order,
      :provider,
      :offset,
      :page,
      :per,
      :sample,
      :query,
      :lat,
      :long,
      :radius,
      :site,
      :service,
      :q
    ]
    parameters = {}

    params[:page] = 1 unless params[:page]
    params[:per] = 30 unless params[:per]

    allowed_parameters.each do |param|
      parameters[param] = params[param] if params[param]
    end
    parameters
  end
end
