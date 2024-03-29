class CreateSessions < ActiveRecord::Migration[7.1]
  def change
    create_table :sessions, id: :uuid do |t|
      t.references :user, type: :uuid, null: false, foreign_key: true
      t.string :token, null: false, index: true
      t.datetime :expiry_at, index: true
      t.datetime :last_request_at
      t.text :user_agent
      t.string :create_ip
      t.string :last_request_ip

      t.timestamps
    end
  end
end
