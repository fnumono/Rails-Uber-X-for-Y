ActiveAdmin.register Client do

	# See permitted parameters documentation:
	# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
	#
	permit_params :fname, :lname, :email, :address1, :address2, :phone1, :phone2, :photo
	#
	# or
	#
	# permit_params do
	#   permitted = [:permitted, :attributes]
	#   permitted << :other if resource.something?
	#   permitted
	# end
	# menu false

end
