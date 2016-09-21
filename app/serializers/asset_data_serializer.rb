class AssetDataSerializer < ActiveModel::Serializer
  attribute :data_object

  def data_object
    {
      id: object["id"],
      type: object["type"],
      data: object["data"]
    }
  end
end
