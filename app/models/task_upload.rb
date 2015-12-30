class TaskUpload < ActiveRecord::Base
	belongs_to :task

	has_attached_file :upload, styles: { medium: "100x100>", thumb: "50x50>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :upload, content_type: /\Aimage\/.*\Z/
	
  def attributes
  	a = super
  	a[:uploadThumbUrl] = nil
  	a[:uploadUrl] = nil  	
  	a
  end

  def uploadUrl  
  	Settings.host_url + upload.url if !upload.url.nil?
  end  

  def uploadThumbUrl  
    Settings.host_url + upload.url(:thumb) if !upload.url.nil?
  end  


end
