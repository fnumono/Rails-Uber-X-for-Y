ActiveAdmin.register Provider do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :fname, :lname, :email, :address1, :address2, :phone1, :phone2, :photo	

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
	  column :address2
	  column :phone1
	  column :phone2	  
	  
	  actions	
	end

	form do |f|
	  f.semantic_errors # shows errors on :base
	  
	  f.inputs "Provider" do          # builds an input field for every attribute
	  	f.input :email
	  	f.input :fname
	  	f.input :lname
	  	f.input :address1
	  	f.input :address2
	  	f.input :phone1
	  	f.input :phone2
	  	# f.input :lname
	  	
	  end	

	  f.actions         # adds the 'Submit' and 'Cancel' buttons
	end
end
