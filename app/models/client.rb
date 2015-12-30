class Client < ActiveRecord::Base
  has_many :tasks

  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          :confirmable, :omniauthable
  include DeviseTokenAuth::Concerns::User

  has_attached_file :photo, styles: { medium: "160x160!", thumb: "40x40!" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :photo, content_type: /\Aimage\/.*\Z/

  
  def attributes
  	a = super
  	a[:photoUrl] = nil
    a[:photoThumbUrl] = nil
  	a
  end

  def photoUrl  
  	Settings.host_url + photo.url(:medium) if !photo.url.nil?
  end  

  def photoThumbUrl  
    Settings.host_url + photo.url(:thumb) if !photo.url.nil?
  end  
end