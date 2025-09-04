class CreateRuns < ActiveRecord::Migration[8.0]
  def change
    create_table :runs do |t|
      t.integer :distance
      t.integer :time

      t.timestamps
    end
  end
end
