class AddAttributesToClient < ActiveRecord::Migration
  def change
    add_column :clients, :fname, :string
    add_column :clients, :lname, :string
    add_column :clients, :address1, :string
    add_column :clients, :address2, :string
    add_column :clients, :phone1, :string
    add_column :clients, :phone2, :string
  end
end
