class Token < ActiveRecord::Base
  attr_accessible :secret

  belongs_to :user

  validates :secret, :user, :presence => true

  def self.create_from_auth_code(auth_code)
    new(:secret => token_for(auth_code))
  end

  private

  def self.token_for(auth_code)
    Highrise::Token.new(auth_code).secret
  rescue
    nil
  end
end
