class Client < ActiveRecord::Base
  has_many :tasks
  has_one :escrow_hour, dependent: :destroy
  belongs_to :zoom_office
  has_many :notifications

  accepts_nested_attributes_for :escrow_hour, allow_destroy: true

  after_create :new_escrow_hour
  before_destroy :release_task

  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          :confirmable, :omniauthable
  include DeviseTokenAuth::Concerns::User

  has_attached_file :photo, styles: { medium: "160x160!", thumb: "40x40!" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :photo, content_type: /\Aimage\/.*\Z/

  def new_escrow_hour
    EscrowHour.create(client_id: id)
  end
  
  def attributes
  	a = super
  	a[:photoUrl] = nil
    a[:photoThumbUrl] = nil
    a[:escrow_hour] = nil
  	a
  end

  def photoUrl  
  	Settings.host_url + photo.url(:medium) if !photo.url.nil?
  end  

  def photoThumbUrl  
    Settings.host_url + photo.url(:thumb) if !photo.url.nil?
  end 

  private
    def release_task
      self.tasks = []
    end 
end