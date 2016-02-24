ActiveAdmin.register Client do

	# See permitted parameters documentation:
	# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
	#
	permit_params :fname, :lname, :email, :address1, :address2, :phone1, :phone2, :photo  ,	\
								:city, :state, :zip, :zoom_office_id
								# escrow_hour_attributes: [:hoursavail, :hoursused, :escrowavail, :escrowused]

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
	  column :photo do |client|
	  	link_to image_tag(client.photo.url(:thumb)), client.photo.url
	  end
	  column :email
	  column :fname
	  column :lname	  
	  column :address1, sortable: false
	  column :city
	  column :state
	  column :zip	  
	  # column :address2
	  column :phone1
	  column :phone2	
	  column 'HoursAvail' do |client|
	  	client.escrow_hour.hoursavail
	  end
	  column 'HoursUsed' do |client|
	  	client.escrow_hour.hoursused
	  end
	  column 'EscrowAvail' do |client|
	  	client.escrow_hour.escrowavail
	  end
	  column 'EscrowUsed' do |client|
	  	client.escrow_hour.escrowused
	  end
	  column 'ZoomOffice' do |client|
	  	client.zoom_office.longName if !client.zoom_office.nil?
	  end

	  actions	
	end

	filter :zoom_office
  filter :email
  filter :fname
	filter :lname
	filter :address1
	filter :phone1
  filter :sign_in_count
  filter :city
  filter :state
  filter :zip
  filter :created_at

	form do |f|
	  f.semantic_errors # shows errors on :base
	  
	  f.inputs "Client" do          # builds an input field for every attribute
	  	f.input :email
	  	f.input :photo
	  	f.input :fname
	  	f.input :lname
	  	f.input :address1
	  	f.input :address2
	  	f.input :phone1
	  	f.input :phone2
	  	f.input :city
		  f.input :state
		  f.input :zip
		  # f.input :zoom_office, :label => "Genre", as: :select, multiple: true, :collection => Genre.all.map{ |genre| [genre.name, genre.id] }, :prompt => 'Select one'
	  	f.input :zoom_office, as: :select, multiple: false, :collection => ZoomOffice.all.map{ |office| [office.longName, office.id] }, :prompt => 'Select one'
	  	# f.inputs  do
	  	# 	f.has_many :escrow_hour, heading: 'Escrow Hour', new_record: false do |a|
    #     	a.input :hoursavail
    #     	a.input :hoursused
    #     	a.input :escrowavail
    #     	a.input :escrowused
    #   	end
    #   end
	  end	
	  f.actions         # adds the 'Submit' and 'Cancel' buttons
	end

	show do
		attributes_table do
			row :id 
		  row :photo do |client|
		  	link_to image_tag(client.photo.url(:thumb)), client.photo.url
		  end
		  row :email
		  row :fname
		  row :lname	  
		  row :address1
		  row :city
		  row :state
		  row :zip	  
		  # row :address2
		  row :phone1
		  row :phone2	
		  row 'HoursAvail' do |client|
		  	client.escrow_hour.hoursavail
		  end
		  row 'HoursUsed' do |client|
		  	client.escrow_hour.hoursused
		  end
		  row 'EscrowAvail' do |client|
		  	client.escrow_hour.escrowavail
		  end
		  row 'EscrowUsed' do |client|
		  	client.escrow_hour.escrowused
		  end
		  row 'ZoomOffice' do |client|
		  	client.zoom_office.longName if !client.zoom_office.nil?
		  end 
		  row :created_at
		  row :updated_at
		end
		
    panel "Client Errand History" do
      table_for client.tasks.order(datetime: :DESC) do
        column :id
        column 'Title' do |task|
        	link_to task.title, admin_task_path(task)
        end
        column :datetime
        column 'Type' do |task|
        	task.type.name
        end
        column 'Provider' do |task|
        	link_to "#{task.provider.fname} #{task.provider.lname}", admin_provider_path(task.provider) \
        	if !task.provider.nil?
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

	
end
