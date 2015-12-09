class AddCityStateZipToProvider < ActiveRecord::Migration
  def change
    add_column :providers, :city, :string
    add_column :providers, :state, :string
    add_column :providers, :zip, :string
  end
end
