class Type < ActiveRecord::Base
	has_and_belongs_to_many :settings
	has_many :tasks

	validates :name, uniqueness: true
end
