class AssetLightWeightSerializer < ActiveModel::Serializer
  attributes :id, :type, :position

  def id
    object[:id]
  end

  def type
    object[:type]
  end

  def position
    if object[:position]
      {
        latitude: object[:position][:latitude],
        longitude: object[:position][:longitude],
      }
    else
      nil
    end
  end
end
