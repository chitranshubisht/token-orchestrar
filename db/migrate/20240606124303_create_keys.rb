class CreateKeys < ActiveRecord::Migration[6.1]
  def change
    create_table :keys do |t|
      t.string :token, null: false
      t.boolean :blocked, default: false
      t.datetime :blocked_at
      t.boolean :keep_alive, default: true

      t.timestamps
    end

    add_index :keys, :token, unique: true
  end
end
