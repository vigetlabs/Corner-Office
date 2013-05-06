class Token < ActiveRecord::Base
  attr_accessible :secret

  belongs_to :user

  validates :secret, :user, :presence => true

  def self.new_from_auth_code(auth_code)
    new(:secret => token_for(auth_code))
  end

  private

  def self.token_for(auth_code)
    Highrise::Token.new(auth_code).to_s
  rescue OAuth2::Error
    nil
  end
end
