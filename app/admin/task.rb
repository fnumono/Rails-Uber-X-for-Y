ActiveAdmin.register Task do
  config.sort_order = 'datetime_desc'
	menu priority: 1, label: 'Errands'

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :title, :datetime, :address, :contact, :details, :escrowable, :usedHour, :usedEscrow, \
                  :client_id, :provider_id, :status, :type_id, :zoom_office_id, :addrlng, :addrlat, \
                  :unit, :pick_up_address, :pick_up_addrlat, :pick_up_addrlng, :pick_up_unit, :item, \
                  :frequency, task_uploads_attributes: [:upload, :id, :_destroy, :task_id]
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if resource.something?
#   permitted
# end

	scope "All", if: proc { true } do |tasks|
	  tasks.all
	end

	scope "Open", if: proc { true } do |tasks|
	  tasks.where(status: 'open')
	end

	scope "Close", if: proc { true } do |tasks|
	  tasks.where(status: 'close')
	end

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

	index :title => 'Errands' do
		selectable_column
		column :id
		column 'Errand Title' do |task|
			link_to task.title, admin_task_path(task)
		end
		column 'Errand Date', :datetime
		column 'Office' do |task|
			task.zoom_office.longName if !task.zoom_office.nil?
		end
		column "Client" do |task|
			link_to "#{task.client.fname} #{task.client.lname}", admin_client_path(task.client) \
			if !task.client.nil?
		end
		column 'Contact #', :contact
		column 'Provider' do |task|
    	link_to "#{task.provider.fname} #{task.provider.lname}", admin_provider_path(task.provider) \
    	if !task.provider.nil?
    end
		column 'Type' do |task|
			task.type.name if !task.type.nil?
		end
		column 'Address', :address, sortable: false
    column :unit
    column :pick_up_address
    column :pick_up_unit
    column :item
		# column :addrlat
		# column :addrlng
		# column 'Escrow Usable', :escrowable
    column :frequency
		column 'Escrow Used', :usedEscrow
		column 'Hours Used', :usedHour
		column :status
		# column :created_at
		# column :updated_at

		actions
	end

	show  do
    attributes_table  do
      row :id
			row :title
			row :datetime
			row 'Office' do |task|
				task.zoom_office.longName
			end
			row :client do |task|
				link_to "#{task.client.fname} #{task.client.lname}", admin_client_path(task.client) \
				if !task.client.nil?
			end
			row :contact
			row 'Provider' do |task|
	    	link_to "#{task.provider.fname} #{task.provider.lname}", admin_provider_path(task.provider) \
	    	if !task.provider.nil?
	    end
			row 'Type' do |task|
				task.type.name
			end
			row :address
      row :unit
			row :addrlat
			row :addrlng
      row :pick_up_address
      row :pick_up_unit
      row :pick_up_addrlat
      row :pick_up_addrlng
      row :item
			row :details
      row :frequency
			row :escrowable
			row :usedHour
			row :usedEscrow
			row :status
			row :created_at
			row :updated_at

    end

    panel "Uploads" do
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
	  					:collection => Client.all.map{ |client| [client.fname.to_s + ' ' + client.lname.to_s, client.id] }, :prompt => 'Select one'
	  	f.input :provider, as: :select, multiple: false, \
	  					:collection => Provider.all.map{ |provider| [provider.fname.to_s + ' ' + provider.lname.to_s, provider.id] }, :prompt => 'Select one'
	  	f.input :zoom_office, as: :select, multiple: false, \
	  					:collection => ZoomOffice.all.map{ |office| [office.longName, office.id] }, :prompt => 'Select one'
	  	f.input :address
      f.input :unit
	  	f.input :addrlat
	  	f.input :addrlng
      f.input :pick_up_address
      f.input :pick_up_unit
      f.input :item
      f.input :pick_up_addrlat
      f.input :pick_up_addrlng
			f.input :contact
			f.input :details
      f.input :frequency
			f.input :escrowable
			f.input :usedHour
			f.input :usedEscrow
			f.input :status, as: :select, collection: ['open', 'close'] , :prompt => 'Select one'

			f.inputs do
				f.has_many :task_uploads, heading: 'Uploads', allow_destroy: true  do |a|
					a.input :upload
				end
			end
	  end

	  f.actions         # adds the 'Submit' and 'Cancel' buttons
	end



end
