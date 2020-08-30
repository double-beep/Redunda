class CreateStatistics < ActiveRecord::Migration[5.1]
  def change
    create_table :statistics do |t|
      t.integer :bot_instance_id
      t.integer :pings_sent
      t.integer :api_quota

      t.timestamps null: false
    end
  end
end
