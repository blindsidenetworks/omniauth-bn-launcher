require 'omniauth'
require 'digest'
require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class BnLauncher < OmniAuth::Strategies::OAuth2

      option :name, 'bn_launcher'
      option :customer, nil
      option :default_callback_url, nil

      def request_phase
        options.authorize_params[:customer] = options[:customer]
        super
      end

      def callback_url
        if options[:default_callback_url].nil?
          fail!(:callback_url_not_set)
        end
        options[:default_callback_url] + script_name + callback_path + query_string
      rescue => e
        fail!(e.message)
      end

      def redirect_url
        # Should remove the gl_redirect_url has that is used for the old launcher
        if !request.params["customer"].nil?
          customer_redirect_url = "#{request.scheme}://#{request.params["customer"]}.#{request.host}:#{request.port}"
          customer_redirect_url + script_name + callback_path + query_string
        else
          #should be changed to customer once the old launcher is removed
          fail!(:customer_not_set)
        end
      rescue => e
        fail!(e.message)
      end

      def callback_phase
        if request.base_url == options[:default_callback_url]
          response = Rack::Response.new
          response.redirect redirect_url
          response.finish
        elsif !request.params["message"].nil?
          fail!(request.params["message"])
        else
          super
        end
      end

      # These are called after authentication has succeeded. If
      # possible, you should try to set the UID without making
      # additional calls (if the user id is returned with the token
      # or as a URI parameter). This may not be possible with all
      # providers.
      uid{ raw_info['uid'] }

      info do
        {
            :name => raw_info['name'],
            :email => raw_info['email'],
            :image => raw_info['image'],
            :username => raw_info['username'],
            :customer => options[:customer],
            :roles => raw_info['roles']
        }
      end

      extra do
        {
            'raw_info' => raw_info
        }
      end

      def raw_info
        @raw_info ||= access_token.get("/user").parsed
      end
    end
  end
end
