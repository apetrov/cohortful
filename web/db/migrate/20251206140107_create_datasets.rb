class CreateDatasets < ActiveRecord::Migration[7.1]
  def change
    create_table :datasets do |t|
      t.string :url, null: true
      t.string :feature_name, null: false
      t.string :arpu_name,  null: false
      t.string :arpu_std_name,  null: false
      t.string :size_name, null: false

      t.timestamps
    end
  end
end
