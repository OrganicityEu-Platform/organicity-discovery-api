class AssetSerializer < ActiveModel::Serializer
  attributes :id, :type, :context

  def id
    object[:id].split(':')[-1]
  end

  def type
    object[:id].split(':')[-3]
  end

  def context
    {
      service: type,
      provider: object[:id].split(':')[-2],
      group: nil,
      name: id,
      last_reading_at: object[:last_reading_at],
      position: object[:position]
    }
  end
end
