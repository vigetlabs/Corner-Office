class CreateTokens < ActiveRecord::Migration
  def change
    create_table :tokens do |t|
      t.string :secret, :limit => 400, :null => false
      t.references :user, :null => false

      t.timestamps
    end
  end
end
