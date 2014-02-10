class CreateTables < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
    end

    create_table :totals do |t|
      t.integer :user_id
      t.integer :total
    end

    create_table :items do |t|
      t.integer :user_id
      t.integer :total_id
      t.integer :count
    end

    add_foreign_key :totals, :users

    add_foreign_key :items, :users
    add_foreign_key :items, :totals
  end
end
