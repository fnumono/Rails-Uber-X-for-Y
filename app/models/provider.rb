class Provider < ActiveRecord::Base
  # Include default devise modules.
  has_one :setting, dependent: :destroy
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          :confirmable, :omniauthable
  include DeviseTokenAuth::Concerns::User

  after_create :create_setting

  has_attached_file :photo, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :photo, content_type: /\Aimage\/.*\Z/

  has_attached_file :driverlicense, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :driverlicense, content_type: /\Aimage\/.*\Z/

  has_attached_file :proofinsurance, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :proofinsurance, content_type: /\Aimage\/.*\Z/

  def attributes
  	a = super
  	a[:photoUrl] = nil
  	a
  end

  def photoUrl
  	Settings.host_url + photo.url(:thumb) if !photo.url.nil?
  end

  private

  def create_setting
    Setting.create!(provider_id: id)
  end


end

