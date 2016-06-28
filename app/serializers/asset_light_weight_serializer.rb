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
        latitude: object[:position]["latitude"],
        longitude: object[:position]["longitude"]
      }
    elsif object[:position][:latitude] and object[:position][:longitude]
      {
        latitude: object[:position][:latitude],
        longitude: object[:position][:longitude]
      }
    else
      "null"
    end
  end
end
