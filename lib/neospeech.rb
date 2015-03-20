require "neospeech/version"
require "neospeech/string"
require "neospeech/convertor"

module Neospeech

  mattr_accessor :email, :account_id, :login_key, :login_password, :engine

  def self.setup
    yield self
  end

  def self.account_auth
    {
      email: email,
      account_id: account_id
    }
  end

  def self.api_auth
    {
      login_key: login_key,
      login_password: login_password
    }
  end

  def self.conversion_engine
    engine
  end
end
