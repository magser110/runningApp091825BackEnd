class AddDateToRuns < ActiveRecord::Migration[8.0]
  def change
    add_column :runs, :date, :datetime
  end
end
