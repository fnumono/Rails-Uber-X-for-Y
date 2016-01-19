ActiveAdmin.register Provider do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :fname, :lname, :email, :address1, :address2, :phone1, \
							:phone2, :photo, :city, :state, :zip, :addrlat, :addrlng, :zoom_Office_id

	index do
		selectable_column
	  column :id 
	  column :photo do |provider|
	  	image_tag(provider.photo.url(:thumb))
	  end
	  column :email
	  column :fname
	  column :lname	  
	  column :address1
	  column :city
	  column :state
	  column :zip
	  # column :address2
	  column :phone1
	  # column :phone2	
	  column :setting 
	  column :addrlat
	  column :addrlng 
	  column :zoom_Office
	  
	  actions	
	end

	show do
    attributes_table do
      row :email
      row :photo do |provider|
        image_tag provider.photo.url(:thumb)
      end
      row :fname
      row :lname
      row :address1
      # row :address2
      row :city
      row :state
      row :zip
      row :addrlat
      row :addrlng
      row :zoom_Office
      row :phone1

      # row :phone2      
      row :driverlicense do |provider|
      	link_to provider.driverlicense.url, provider.driverlicense.url
      end
      row :proofinsurance do |provider|
      	link_to provider.proofinsurance.url, provider.proofinsurance.url
      end	
      row :setting
      
    end
    active_admin_comments
  end

	form do |f|
	  f.semantic_errors # shows errors on :base
	  
	  f.inputs "Provider" do          # builds an input field for every attribute
	  	f.input :email
	  	f.input :fname
	  	f.input :lname
	  	f.input :address1
	  	# f.input :address2
	  	f.input :city
	  	f.input :state
	  	f.input :zip
	  	f.input :addrlat
	  	f.input :addrlng
	  	f.input :zoom_Office
	  	f.input :phone1
	  	# f.input :phone2
	  	# f.input :
	  	
	  end	

	  f.actions         # adds the 'Submit' and 'Cancel' buttons
	end
end
