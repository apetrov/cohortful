class CreateBackgroundJobs < ActiveRecord::Migration[7.1]
  def change
    create_table :background_jobs do |t|
      t.string :queue
      t.jsonb :payload
      t.string :status, default: "pending"
      t.integer :attempts, default: 0
      t.timestamps
    end
  end
end
