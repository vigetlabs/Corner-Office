class Token < ActiveRecord::Base
  attr_accessible :secret

  after_create :set_default_site_for_user

  belongs_to :user

  validates :secret, :user, :presence => true

  def self.create_from_auth_code(auth_code)
    create(:secret => token_for(auth_code))
  end

  private

  def set_default_site_for_user
    user.set_default_site
  end

  def self.token_for(auth_code)
    Highrise::Token.new(auth_code).to_s
  rescue OAuth2::Error
    nil
  end
end
