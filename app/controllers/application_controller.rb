class ApplicationController < ActionController::API
    def generate_token(user)
        unique_key = Rails.application.secrets.secret_key_base
        data = {
            userid: user.id,
            expires: 24.hours.from_now
        }
        JWT.encode data, unique_key, 'HS256'
    end

    def auth_user_from_header_token
        token = request.headers['Authorization']
        unique_key = Rails.application.secrets.secret_key_base
        begin
            decoded = JWT.decode token, unique_key, true, { algorithm: 'HS256' }
            expires = Time.parse(decoded[0]['expires'])
            if expires < Time.now
                return nil
            end
            decoded[0]['userid']
        rescue
            nil
        end
    end
end
