class User < ApplicationRecord
  validates :email,
  uniqueness: { case_sensitive: false}, 
  presence: true,
  format: { with: URI::MailTo::EMAIL_REGEXP }
  # lets make sure we downcase the email before saving it
  before_save { self.email = email.downcase }
  
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :summary, optional: true
  
  # generates auth token to authenticate the further requests once user is authenticated
  def generate_auth_token
    self.login_token = nil
    self.login_token_verified_at = Time.now
    self.save
  
    payload = {
      user_id: id,
      login_token_verified_at: login_token_verified_at,
      exp: 1.day.from_now.to_i
    }
  
    generate_token(payload)
  end

  def send_magic_link
    generate_login_token

    UserMailer.magic_link(self, login_link).deliver_now
  end

  def generate_login_token
    payload = { 
      email: email,
      exp: 1.day.from_now.to_i
     }
     self.login_token = generate_token(payload)
     save!
  end

  def login_link
    Rails.application.routes.url_helpers.api_v1_sessions_create_url(login_token: login_token, host: 'localhost:3000')
  end


  private

  def generate_token(payload)
    JsonWebToken.encode(payload)
  end
end
