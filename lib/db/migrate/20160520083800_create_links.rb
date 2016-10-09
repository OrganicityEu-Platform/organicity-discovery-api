class CreateLinks < ActiveRecord::Migration[5.0]
  def change
    create_table :links do |t|
      t.string            :url
      t.string            :relationship
      t.integer           :linkable_id
      t.string            :linkable_type
      t.timestamps
    end
  end
end
