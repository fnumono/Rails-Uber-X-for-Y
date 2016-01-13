class Task < ActiveRecord::Base
  belongs_to :client
  belongs_to :provider
  belongs_to :type
  has_many :task_uploads, dependent: :destroy
  belongs_to :zoom_city

  accepts_nested_attributes_for :task_uploads

  def attributes
  	a = super
  	a[:client] = nil
  	a[:provider] = nil
  	a[:type] = nil
    a[:task_uploads] = nil
  	a
  end

end