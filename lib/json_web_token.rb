require "jwt"

class JsonWebToken
  class << self
    def encode(payload)
      payload.reverse_merge!(meta)
      JWT.encode(payload, secret_key_base)
    end

    def decode(token)
      JWT.decode(token, secret_key_base).first
    rescue JWT::DecodeError => e
      raise "Invalid token: #{e.message}"
    end

    def valid_payload(payload)
      !(expired(payload) || payload['iss'] != meta[:iss] || payload['aud'] != meta[:aud])
    end

    def meta
      {
        exp: 1.day.from_now.to_i,
        iss: Rails.application.credentials.dig(:jwt, :issuer) || 'issuer_name',
        aud: Rails.application.credentials.dig(:jwt, :audience) || 'client',
      }
    end

    def expired(payload)
      Time.at(payload['exp']) < Time.now
    end

    private

    def secret_key_base
      Rails.application.credentials.secret_key_base
    end
  end
end