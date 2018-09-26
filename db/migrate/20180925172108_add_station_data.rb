class AddStationData < ActiveRecord::Migration[5.1]
  def change

    reversible do |change|
      change.up do
        data = {}

        File.readlines(File.join(Rails.root, 'db', 'data', 'London tube lines.csv')).each do |line|
          line, from_name, to_name = line.gsub("\n", '').split(',')

          # Ignore CSV header
          next if from_name == 'From Station'
          
          # # ignoring these lines to match example given
          # next if line.in?(['C2C', 'Greater Anglia', 'TfL Rail'])

          from = Station.find_or_create_by(name: from_name)
          to = Station.find_or_create_by(name: to_name)
          
          # Assuming the trains go both ways, easier to double up the links for now
          StationLink.find_or_create_by(tube_line: line, from_id: from.id, to_id: to.id)
          StationLink.find_or_create_by(tube_line: line, from_id: to.id, to_id: from.id)
        end
      end
      
      change.down do
        Station.delete_all
        StationLink.delete_all
      end
    end
  end
end
