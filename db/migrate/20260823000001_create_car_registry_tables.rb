# frozen_string_literal: true

class CreateCarRegistryTables < ActiveRecord::Migration[7.0]
  def change
    create_table :car_models do |t|
      t.string :name, null: false
      t.integer :position, default: 0
      t.timestamps
    end

    add_index :car_models, :name, unique: true

    create_table :car_locations do |t|
      t.string :name, null: false
      t.integer :position, default: 0
      t.timestamps
    end

    add_index :car_locations, :name, unique: true

    create_table :car_registry_entries do |t|
      t.integer :user_id, index: true
      t.string :username, null: false, default: ""
      t.integer :model_id, index: true
      t.integer :location_id, index: true
      t.string :colour
      t.string :trim
      t.string :plaque_number
      t.string :reg_number
      t.datetime :car_reg_date
      t.string :forum_name
      t.text :unique_information
      t.timestamps
    end

    add_index :car_registry_entries, :username
    add_index :car_registry_entries, :reg_number
    add_index :car_registry_entries, :plaque_number
  end
end
