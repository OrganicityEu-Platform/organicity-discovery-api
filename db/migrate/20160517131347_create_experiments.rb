class CreateExperiments < ActiveRecord::Migration[5.0]
  def change
    create_table :experiments do |t|

      t.timestamps
    end
  end
end
