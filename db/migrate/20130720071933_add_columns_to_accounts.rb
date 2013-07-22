class AddColumnsToAccounts < ActiveRecord::Migration
  def change
  	add_column :accounts, :gender, :string
  	add_column :accounts, :birthday, :datetime
  	add_column :accounts, :qq, :string
  	add_column :accounts, :phone, :string
  end
end
