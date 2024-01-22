class CreateGameEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :game_events, id: :uuid  do |t|
      t.integer :type
      t.datetime :occurred_at, index: true
      t.references :game, type: :uuid, null: false, foreign_key: true
      t.references :user, type: :uuid, null: false, foreign_key: true

      t.timestamps
    end
  end
end
