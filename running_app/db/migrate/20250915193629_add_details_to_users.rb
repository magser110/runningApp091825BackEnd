class AddDetailsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :email, :string
    add_column :users, :height, :float
    add_column :users, :weight, :float
    add_column :users, :gender, :string
    add_column :users, :age, :integer
  end
end
