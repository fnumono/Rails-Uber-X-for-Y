class Provider < ActiveRecord::Base
  # Include default devise modules.
  has_one :setting, dependent: :destroy
  has_many :tasks
  belongs_to :zoom_county
  
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          :confirmable, :omniauthable
  include DeviseTokenAuth::Concerns::User

  after_create :create_setting

  has_attached_file :photo, styles: { medium: "160x160!", thumb: "30x30!" } , default_url: "/images/:style/missing.png"
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
  	Settings.host_url + photo.url(:medium) if !photo.url.nil?
  end

  def photoThumbUrl
    Settings.host_url + photo.url(:thumb) if !photo.url.nil?
  end

  def driverUrl
    Settings.host_url + driverlicense.url(:thumb) if !driverlicense.url.nil?
  end

  def proofUrl
    Settings.host_url + proofinsurance.url(:thumb) if !proofinsurance.url.nil?
  end

  private

  def create_setting
    Setting.create!(provider_id: id)
  end


end

