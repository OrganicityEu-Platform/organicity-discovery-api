class CreateExperimenters < ActiveRecord::Migration[5.0]
  def change
    create_table :experimenters do |t|

      t.timestamps
    end
  end
end
