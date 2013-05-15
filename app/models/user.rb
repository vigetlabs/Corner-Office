class User < ActiveRecord::Base
  include SimplestAuth::Model
  include PasswordResettable

  authenticate_by :email

  has_many :tokens, :order => "created_at DESC", :after_add => :set_default_site

  attr_accessible :password, :password_confirmation, :email, :first_name, :last_name, :site

  validates :first_name, :last_name, :email, :presence => true
  validates :email, :email => true, :uniqueness => true

  validates :password, :length => {:minimum => 8}, :if => :password_required?
  validates :password, :presence => true, :on => :create
  validates :password_confirmation, :presence => true, :on => :create
  validates :password, :confirmation => true

  def name
    "#{first_name} #{last_name}"
  end

  def token
    tokens.first
  end

  def highrise_sites
    @highrise_sites ||= authorization.highrise_sites if authorization
  end

  def unauthorized_token?
    token && !authorization
  end

  def set_default_site
    if highrise_sites && highrise_sites.count == 1
      update_attributes(:site => highrise_sites.first[1])
    end
  end

  private

  def authorization
    @authorization ||= get_authorization
  end

  def get_authorization
    if token.present?
      Highrise::Base.oauth_token = token.secret
      Highrise::Authorization.retrieve
    end
  end
end
