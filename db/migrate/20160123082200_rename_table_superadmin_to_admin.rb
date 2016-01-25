class RenameTableSuperadminToAdmin < ActiveRecord::Migration
  def change
  	rename_table :superadmins, :admins
  end
end
