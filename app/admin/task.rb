ActiveAdmin.register Task do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :title, :datetime, :address, :contact, :details, :escrowable, :usedHour, :usedEscrow, \
                  :client_id, :provider_id, :status, :type_id, :zoom_city_id, task_uploads: []
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if resource.something?
#   permitted
# end


end
