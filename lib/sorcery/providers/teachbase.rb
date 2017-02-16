module Sorcery
  module Providers
    class Teachbase < Base
      include Protocols::Oauth2

      attr_reader   :mode, :param_name, :parse
      attr_accessor :site

      def initialize
        super

        @token_url = 'oauth/token'
        @auth_path = 'oauth/authorize'
        @user_info_path = 'me'
      end

      def get_user_hash(access_token)
        response = access_token.get(@user_info_path)

        auth_hash(access_token).tap do |h|
          h[:user_info] = JSON.parse(response.body)
          h[:uid] = h[:user_info]['id']
          h[:uid] = h[:user_info]['id']
        end
      end

      # calculates and returns the url to which the user should be redirected,
      # to get authenticated at the external provider's site.
      def login_url(_params, _session)
        authorize_url authorize_url: @auth_path
      end

      # tries to login the user from access token
      def process_callback(params, _session)
        args = {}.tap do |a|
          a[:code] = params[:code] if params[:code]
        end

        get_access_token(args, token_url: @token_url, token_method: :post)
      end
    end
  end
end

