ActiveAdmin.register Provider do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :fname, :lname, :email, :address1, :address2, :phone1, :active, :driverlicense, \
		:proofinsurance,	:phone2, :photo, :city, :state, :zip, :addrlat, :addrlng, :zoom_Office_id

	controller do
    def scoped_collection    	
    	if current_admin.email == 'superadmin@zoomerrands.com'
    		end_of_association_chain
    	else
    		office = current_admin.zoom_office
      	end_of_association_chain.where(zoom_office: office)
      end
    end
  end	
	
	index do
		selectable_column
	  column :id 
	  column :photo do |provider|
	  	link_to image_tag(provider.photo.url(:thumb)), provider.photo.url
	  end
	  column :email
	  column :fname
	  column :lname	
	  column 'ZoomOffice' do |client|
	  	client.zoom_office.longName if !client.zoom_office.nil?
	  end  
	  column :address1
	  column :address2	  
	  column :phone1
	  column :addrlat
	  column :addrlng
	  column :driverlicense do |provider|
	  	link_to 'License', provider.driverlicense.url
	  end
	  column :proofinsurance do |provider|
	  	link_to 'Insurance', provider.proofinsurance.url
	  end
	  column :available do |provider|
	  	provider.setting.available
	  end
	  column :sms do |provider|
	  	provider.setting.sms
	  end
	  column :email do |provider|
	  	provider.setting.email
	  end
	  column :a1099 do |provider|
	  	provider.setting.a1099
	  end
	  column :noncompete do |provider|
	  	provider.setting.noncompete
	  end
	  column :confidentiality do |provider|
	  	provider.setting.confidentiality
	  end
	  column :delivery do |provider|
	  	provider.setting.delivery
	  end
	  column :types do |provider|
		  	provider.setting.types.map { |type| type.name  }
		  end 
	  column :active


	  actions	
	end

	filter :zoom_office
  filter :email
  filter :fname
	filter :lname
	filter :address1
	filter :phone1
  filter :sign_in_count
  filter :created_at


	show do
    attributes_table do
      row :id 
		  row :photo do |provider|
		  	link_to image_tag(provider.photo.url(:thumb)), provider.photo.url
		  end
		  row :email
		  row :fname
		  row :lname	
		  row 'ZoomOffice' do |client|
		  	client.zoom_office.longName if !client.zoom_office.nil?
		  end  
		  row :address1
		  row :address2	  
		  row :phone1
		  row :addrlat
		  row :addrlng
		  row :driverlicense do |provider|
		  	link_to 'License', provider.driverlicense.url
		  end
		  row :proofinsurance do |provider|
		  	link_to 'Insurance', provider.proofinsurance.url
		  end
		  row :sms do |provider|
		  	provider.setting.sms
		  end
		  row :email do |provider|
		  	provider.setting.email
		  end
		  row :a1099 do |provider|
		  	provider.setting.a1099
		  end
		  row :noncompete do |provider|
		  	provider.setting.noncompete
		  end
		  row :confidentiality do |provider|
		  	provider.setting.confidentiality
		  end
		  row :delivery do |provider|
		  	provider.setting.delivery
		  end
		  row :types do |provider|
		  	provider.setting.types.map { |type| type.name  }
		  end 
		  row :created_at
		  row :updated_at
		  row :active 
    end

    panel "Provider Task History" do
      table_for provider.tasks.order(datetime: :DESC) do
        column :id
        column 'Title' do |task|
        	link_to task.title, admin_task_path(task)
        end
        column :datetime
        column 'Type' do |task|
        	task.type.name
        end
        column :client do |task|
        	link_to "#{task.client.fname} #{task.client.lname}", admin_client_path(task.client) \
        	if !task.client.nil?
        end        
        column 'Office' do |task|
			  	task.zoom_office.longName
			  end
        column :address
        column :contact
        column :escrowable 
        column :usedHour
        column :usedEscrow
        column :status
        column :created_at
        column :updated_at 
      end
    end  

    active_admin_comments
  end

	form do |f|
	  f.semantic_errors # shows errors on :base
	  
	  f.inputs "Provider" do          # builds an input field for every attribute
	  	f.input :email
	  	f.input :photo
	  	f.input :fname
	  	f.input :lname
	  	f.input :zoom_office, as: :select, multiple: false, \
	  					:collection => ZoomOffice.all.map{ |office| [office.longName, office.id] }, :prompt => 'Select one'
	  	f.input :address1
	  	f.input :address2
	  	f.input :phone1
	  	f.input :addrlat
	  	f.input :addrlng
	  	f.input :driverlicense
	  	f.input :proofinsurance
	  	f.input :active	 
	  	# f.inputs  do
				# f.has_many :setting do |a|
		  #   	# a.input :sms
		  #   	# a.input :email
		  #   	# a.input :a1099
		  #   	# a.input :noncompete
		  #   	# a.input :confidentiality
		  #   	# a.input :delivery
		  # 	end
		  # end	
	  end	
	  

	  f.actions         # adds the 'Submit' and 'Cancel' buttons
	end
end
