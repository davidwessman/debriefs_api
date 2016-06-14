class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.references :user, index: true, foreign_key: true
      t.references :provider, index: true, foreign_key: true
      t.boolean :active, default: true, null: false

      t.timestamps null: false
    end

    add_index(:subscriptions, [:user_id, :provider_id], unique: true)
  end
end
