class CreateDealData < ActiveRecord::Migration
  def change
    create_table :deal_data do |t|
      t.date    :start_date
      t.date    :end_date
      t.integer :probability
      t.integer :average_rate
      t.integer :deal_id

      t.timestamps
    end
    add_index :deal_data, :deal_id, :unique => true
  end
end
