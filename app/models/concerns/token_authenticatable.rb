require 'active_support/core_ext/numeric/time'

module TokenAuthenticatable
  extend ActiveSupport::Concern

  module ClassMethods
    def is_authenticated?(authentication_token = nil)
      if authentication_token
        user = where(authentication_token: authentication_token).first
        return user if user && (user.authentication_token_expiry - Time.now) > 0
      end
    end
  end

  def ensure_authentication_token
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token
      # self.authentication_token_expiry = Time.now + APP_CONFIGS["timeout_in"].minutes
    end
  end

  def reset_authentication_token!
    self.authentication_token = generate_authentication_token
    self.authentication_token_expiry = Time.now + APP_CONFIGS["timeout_in"].minutes
    save
  end

  private

  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      # break token unless self.class.unscoped.where(authentication_token: token).first
      break token unless User.where(authentication_token: token).first
    end
  end
end