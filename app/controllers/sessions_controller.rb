# frozen_string_literal: true

# :nocov:
class SessionsController < Devise::SessionsController
  # See https://medium.com/@fishpercolator/how-to-separate-frontend-backend-with-rails-api-nuxt-js-and-devise-jwt-cf7dd9da9d16
  # Code https://gist.github.com/pedantic-git/2d7db4082dad397fcc8a8f52d72acb31#file-sessions_controller-rb
  def create
    super { @token = current_token }
  end

  def show; end

  private

  def current_token
    request.env["warden-jwt_auth.token"]
  end
end
# :nocov:
