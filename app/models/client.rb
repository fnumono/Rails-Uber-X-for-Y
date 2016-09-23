class Client < ActiveRecord::Base
  has_many :tasks
  has_one :escrow_hour, dependent: :destroy
  belongs_to :zoom_office
  has_many :notifications, dependent: :destroy
  has_many :payments, dependent: :destroy
  has_one :client_setting, dependent: :destroy

  accepts_nested_attributes_for :escrow_hour, allow_destroy: true

  after_create :build_childs
  before_destroy :release_task

  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          :confirmable, :omniauthable
  include DeviseTokenAuth::Concerns::User

  has_attached_file :photo, styles: { medium: "160x160!", thumb: "40x40!" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :photo, content_type: /\Aimage\/.*\Z/

  validates :phone1, uniqueness: true, if: "phone1.present?"

  # Override Devise::Confirmable#after_confirmation
  def after_confirmation
    self.notifications.create(notify_type: Settings.notify_user, name: 'Signed up successfully.', \
            text: 'Your account has been created successfully.')
  end

  def build_childs
    EscrowHour.create(client_id: id)
    self.notifications.create(notify_type: Settings.notify_user, name: 'Thank you.', \
            text: 'Confirmation email has been sent to ' + self.email + '.')
    self.create_client_setting
  end

  def attributes
  	a = super
  	a[:photoUrl] = nil
    a[:photoThumbUrl] = nil
    a[:escrow_hour] = nil
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

  private
    def release_task
      self.tasks = []
    end
end