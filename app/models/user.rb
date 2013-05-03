class User < ActiveRecord::Base
  include SimplestAuth::Model

  authenticate_by :email

  attr_accessible :password, :password_confirmation, :email, :first_name, :last_name

  validates :first_name, :last_name, :email, :presence => true
  validates :email, :email => true, :uniqueness => true

  validates :password, :length => {:minimum => 8}, :if => :password_required?
  validates :password, :presence => true, :on => :create
  validates :password_confirmation, :presence => true, :on => :create
  validates :password, :confirmation => true

  def name
    "#{first_name} #{last_name}"
  end
end
