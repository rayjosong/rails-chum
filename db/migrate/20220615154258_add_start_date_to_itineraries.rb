class AddStartDateToItineraries < ActiveRecord::Migration[6.1]
  def change
    add_column :itineraries, :start_date, :datetime
  end
end
