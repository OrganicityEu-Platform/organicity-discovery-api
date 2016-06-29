class AssetLightWeightSerializer < ActiveModel::Serializer
  attributes :id, :type, :position

  def id
    object[:id]
  end

  def type
    object[:type]
  end

  def position
    object[:position] ? map_position : nil
  end

  def map_position
    if object[:position]["latitude"] and object[:position]["longitude"]
      {
        latitude: object[:position]["latitude"].to_f,
        longitude: object[:position]["longitude"].to_f
      }
    elsif object[:position][:latitude] and object[:position][:longitude]
      {
        latitude: object[:position][:latitude].to_f,
        longitude: object[:position][:longitude].to_f
      }
    else
      "null"
    end
  end
end
