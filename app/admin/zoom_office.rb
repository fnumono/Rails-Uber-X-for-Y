ActiveAdmin.register ZoomOffice do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :shortName, :longName
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if resource.something?
#   permitted
# end

  menu :if => proc{ current_admin.email == 'superadmin@zoomerrands.com' }



end
