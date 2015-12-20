class Task < ActiveRecord::Base
  belongs_to :client
  belongs_to :provider
  has_and_belongs_to_many :types
  has_many :task_uploads

  accepts_nested_attributes_for :task_uploads

  def attributes
  	a = super
  	a[:client] = nil
  	a[:provider] = nil
  	a[:types] = nil
  	a
  end

end
