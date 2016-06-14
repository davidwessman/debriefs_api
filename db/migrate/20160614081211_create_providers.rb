class CreateProviders < ActiveRecord::Migration
  def change
    create_table :providers do |t|
      t.string :title, default: '', null: false
      t.string :url, default: '', null: false
      t.boolean :active, default: false, null: false
      t.text :description

      t.timestamps null: false
    end
  end
end
