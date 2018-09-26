class CreateStations < ActiveRecord::Migration[5.1]
  def change
    create_table :stations do |t|
      t.string :name
    end

    create_table :station_links, id: false do |t|
      t.string :tube_line
      t.integer :from_id
      t.integer :to_id
    end
  end
end
