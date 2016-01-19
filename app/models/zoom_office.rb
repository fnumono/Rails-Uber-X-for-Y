class ZoomOffice < ActiveRecord::Base
	has_many :tasks
	has_many :providers
	has_many :clients
end
