class AddAttributesToProvider < ActiveRecord::Migration
  def change
    add_column :providers, :fname, :string
    add_column :providers, :lname, :string
    add_column :providers, :address1, :string
    add_column :providers, :address2, :string
    add_column :providers, :phone1, :string
    add_column :providers, :phone2, :string
  end
end
