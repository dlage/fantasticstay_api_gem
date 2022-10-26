# frozen_string_literal: true

require_relative 'api/config'
require_relative 'version'

module FantasticstayApi
  # Stores the configuration
  class Configuration < API::Config
    API_ENDPOINT = 'https://api.fsapp.io'
    API_TOKEN = 'TESTING'

    property :follow_redirects, default: true

    # The api endpoint used to connect to FantasticstayApi if none is set
    property :endpoint, default: ENV['FANTASTICSTAY_API_ENDPOINT'] || API_ENDPOINT

    # The token included in request header 'x-api-key'
    property :token, default: ENV['FANTASTICSTAY_API_TOKEN'] || API_TOKEN

    # The value sent in the http header for 'User-Agent' if none is set
    property :user_agent, default: "FantasticstayApi API Ruby Gem #{FantasticstayApi::VERSION}"

    # By default uses the Faraday connection options if none is set
    property :connection_options, default: {}

    # By default display 30 resources
    property :per_page, default: 10

    # Add Faraday::RackBuilder to overwrite middleware
    property :stack
  end
end
