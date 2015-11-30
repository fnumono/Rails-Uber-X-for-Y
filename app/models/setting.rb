class Setting < ActiveRecord::Base
  belongs_to :provider
  has_and_belongs_to_many :types
end
