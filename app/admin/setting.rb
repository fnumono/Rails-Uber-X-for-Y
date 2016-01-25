ActiveAdmin.register Setting do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :provider_id, :a1099, :noncompete, :confidentiality, :delivery, :sms, :email, type_ids: []
#
menu false

index do
  selectable_column
  id_column
  column :provider
  column :a1099
  column :noncompete
  column :confidentiality
  column :delivery
  column :sms
  column :email

  actions
end

show do
    attributes_table do
    	row :provider
      row :a1099      
      row :noncompete
      row :confidentiality
      row :delivery
      row :sms, label: 'Notification_SMS'      
      row :email, label: 'Notification_Email'
      row 'Job Types' do |setting|
        raw(setting.types.map { |type| link_to type.name, admin_type_path(type) }.join(', '))
      end     
      
    end
    active_admin_comments
  end

form do |f|
	  f.semantic_errors # shows errors on :base
	  
	  f.inputs "Provider" do          # builds an input field for every attribute
	  	# f.input :provider
	  	f.input :a1099
	  	f.input :noncompete
	  	f.input :confidentiality
	  	f.input :delivery
	  	f.input :sms
	  	f.input :email
      f.input :type_ids, :label => "Job Type", as: :select, multiple: true, :collection => Type.all.map{ |type| [type.name, type.id] }, :prompt => 'Select one'
	  	
	  end	

	  f.actions         # adds the 'Submit' and 'Cancel' buttons
	end



end
