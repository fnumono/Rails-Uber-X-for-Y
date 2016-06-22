class Provider < ActiveRecord::Base
  # Include default devise modules.
  has_one :setting, dependent: :destroy
  accepts_nested_attributes_for :setting
  
  has_many :tasks
  belongs_to :zoom_office
  
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable ,:confirmable, :omniauthable
  include DeviseTokenAuth::Concerns::User

  after_create :create_setting
  before_destroy :release_task

  has_attached_file :photo, styles: { medium: "190x190!", thumb: "30x30!" } , default_url: "/images/:style/missing.png"
  validates_attachment_content_type :photo, content_type: /\Aimage\/.*\Z/

  has_attached_file :driverlicense, styles: { medium: "300x300>", thumb: "300x100!" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :driverlicense, content_type: /\Aimage\/.*\Z/

  has_attached_file :proofinsurance, styles: { medium: "300x300>", thumb: "300x100!" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :proofinsurance, content_type: /\Aimage\/.*\Z/

  def attributes
  	a = super
  	a[:photoUrl] = nil
    a[:driverUrl] = nil
    a[:proofUrl] = nil
    a[:photoThumbUrl] = nil
  	a
  end

  def photoUrl
    if !photo.url.nil?
      url = photo.url(:medium) 
      url = Settings.host_url + url if url[0..3] != 'http'
      url
    end
  end

  def photoThumbUrl
    if !photo.url.nil?
      url = photo.url(:thumb) 
      url = Settings.host_url + url if url[0..3] != 'http'
      url
    end
  end

  def driverUrl
    if !driverlicense.url.nil?
      url = driverlicense.url(:thumb) 
      url = Settings.host_url + url if url[0..3] != 'http'
      url
    end
  end

  def proofUrl
    if !proofinsurance.url.nil?
      url = proofinsurance.url(:thumb) 
      url = Settings.host_url + url if url[0..3] != 'http'
      url
    end
  end

  private

    def create_setting
      Setting.create!(provider_id: id)
    end

    def release_task
      self.tasks = []
    end


end

