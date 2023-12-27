class CreateExperiments < ActiveRecord::Migration[7.1]
  def change
    create_table :experiments, id: :uuid do |t|
      t.string :key
      t.string :value
      t.float :chance

      t.timestamps
    end
  end
end
