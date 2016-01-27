ActiveAdmin.register Task do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :title, :datetime, :address, :contact, :details, :escrowable, :usedHour, :usedEscrow, \
                  :client_id, :provider_id, :status, :type_id, :zoom_office_id, :addrlng, :addrlat, \
                  task_uploads_attributes: [:upload, :id, :_destroy, :task_id]
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if resource.something?
#   permitted
# end

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
		column 'Title' do |task|
			link_to task.title, admin_task_path(task)
		end
		column :datetime
		column 'Type' do |task|
			task.type.name if !task.type.nil?
		end
		column :client do |task|
			link_to "#{task.client.fname} #{task.client.lname}", admin_client_path(task.client) \
			if !task.client.nil?
		end   
		column 'Provider' do |task|
    	link_to "#{task.provider.fname} #{task.provider.lname}", admin_provider_path(task.provider) \
    	if !task.provider.nil?
    end         
		column 'Office' do |task|
			task.zoom_office.longName if !task.zoom_office.nil?
		end
		column :address
		column :addrlat
		column :addrlng
		column :contact
		column :escrowable 
		column :usedHour
		column :usedEscrow
		column :status
		column :created_at
		column :updated_at 

		actions
	end

	show do
    attributes_table do
      row :id
			row :title
			row :datetime
			row 'Type' do |task|
				task.type.name
			end
			row :client do |task|
				link_to "#{task.client.fname} #{task.client.lname}", admin_client_path(task.client) \
				if !task.client.nil?
			end   
			row 'Provider' do |task|
	    	link_to "#{task.provider.fname} #{task.provider.lname}", admin_provider_path(task.provider) \
	    	if !task.provider.nil?
	    end         
			row 'Office' do |task|
				task.zoom_office.longName
			end
			row :address
			row :addrlat
			row :addrlng
			row :contact
			row :details
			row :escrowable 
			row :usedHour
			row :usedEscrow			
			row :status
			row :created_at
			row :updated_at 

    end

    panel "Receipts" do
      table_for task.task_uploads do
        column :upload do |task_upload|
        	link_to image_tag(task_upload.upload.url(:thumb)), task_upload.upload.url
        end
      end
    end  

    active_admin_comments
  end  

  form do |f|
	  f.semantic_errors # shows errors on :base
	  
	  f.inputs "Task" do          # builds an input field for every attribute
	  	f.input :title, :required => true
	  	f.input :datetime
	  	f.input :type, as: :select, multiple: false, \
	  					:collection => Type.all.map{ |type| [type.name, type.id] }, :prompt => 'Select one'
	  	f.input :client, as: :select, multiple: false, \
	  					:collection => Client.all.map{ |client| [client.fname + ' ' + client.lname, client.id] }, :prompt => 'Select one'				
	  	f.input :provider, as: :select, multiple: false, \
	  					:collection => Provider.all.map{ |provider| [provider.fname + ' ' + provider.lname, provider.id] }, :prompt => 'Select one'				
	  	f.input :zoom_office, as: :select, multiple: false, \
	  					:collection => ZoomOffice.all.map{ |office| [office.longName, office.id] }, :prompt => 'Select one'												
	  	f.input :address
	  	f.input :addrlat
	  	f.input :addrlng
			f.input :contact
			f.input :details
			f.input :escrowable 
			f.input :usedHour
			f.input :usedEscrow			
			f.input :status, as: :select, collection: ['open', 'close'] , :prompt => 'Select one'

			f.inputs do
				f.has_many :task_uploads, heading: 'Receipts', allow_destroy: true  do |a|
					a.input :upload
				end
			end
	  end	  

	  f.actions         # adds the 'Submit' and 'Cancel' buttons
	end	



end
