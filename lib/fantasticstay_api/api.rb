# frozen_string_literal: true

require_relative 'api_exceptions'
require_relative 'constants'
require_relative 'http_status_codes'
require 'dry-configurable'
require 'api_cache'
require 'digest/bubblebabble'

module FantasticstayApi
  # Core class responsible for api interface operations
  class API
    include ApiExceptions
    include Constants
    include HttpStatusCodes
    include Dry::Configurable

    HTTP_STATUS_MAPPING = {
      HTTP_BAD_REQUEST_CODE => BadRequestError,
      HTTP_UNAUTHORIZED_CODE => UnauthorizedError,
      HTTP_FORBIDDEN_CODE => ForbiddenError,
      HTTP_NOT_FOUND_CODE => NotFoundError,
      HTTP_UNPROCESSABLE_ENTITY_CODE => UnprocessableEntityError,
      'default' => ApiError
    }.freeze
    API_ENDPOINT = 'https://api.fsapp.io'
    API_TIMEOUT = 30
    API_TOKEN = 'TESTING'

    setting :follow_redirects, default: true

    # The api endpoint used to connect to FantasticstayApi if none is set
    setting :endpoint, default: ENV['FANTASTICSTAY_API_ENDPOINT'] || API_ENDPOINT, reader: true

    # The timeout in requests made to fsapp
    setting :timeout, default: ENV['FANTASTICSTAY_API_TIMEOUT'] || API_TIMEOUT, reader: true

    # The token included in request header 'x-api-key'
    setting :token, default: ENV['FANTASTICSTAY_API_TOKEN'] || API_TOKEN, reader: true

    # The value sent in the http header for 'User-Agent' if none is set
    setting :user_agent, default: "FantasticstayApi API Ruby Gem #{FantasticstayApi::VERSION}"

    # By default uses the Faraday connection options if none is set
    setting :connection_options, default: {}

    # By default display 30 resources
    setting :per_page, default: 10

    # Add Faraday::RackBuilder to overwrite middleware
    setting :stack

    # Create new API
    #
    # @api public
    def initialize(options = {}, &block)
      configure do |c|
        options.each_key do |key|
          c.send("#{key}=", options[key])
        end
      end

      yield_or_eval(&block) if block_given?
    end

    # Call block with argument
    #
    # @api private
    def yield_or_eval(&block)
      return unless block

      block.arity.positive? ? yield(self) : instance_eval(&block)
    end

    private

    def client
      logger = Logger.new $stderr
      logger.level = Logger::DEBUG
      @client ||= Faraday.new(config.endpoint) do |client|
        client.request :url_encoded
        client.adapter Faraday.default_adapter
        client.headers['Content-Type'] = 'application/json'
        client.headers['x-api-key'] = config.token
        client.headers['User-Agent'] = config.user_agent
        client.options.timeout = config.timeout
        client.response :logger, logger
      end
    end

    def request(http_method:, endpoint:, params: {}, cache_ttl: 3600)
      response = APICache.get(
        Digest::SHA256.bubblebabble(config.token) + http_method.to_s + endpoint + params.to_s,
        cache: cache_ttl
      ) do
        client.public_send(http_method, endpoint, params)
      end

      process_http_response(response)
    end

    def process_http_response(response)
      return Oj.load(response.body) if response_successful?(response)

      raise error_class(response), "Code: #{response.status}, response: #{response.body}"
    end

    def error_class(response)
      if HTTP_STATUS_MAPPING.include?(response.status)
        HTTP_STATUS_MAPPING[response.status]
      else
        HTTP_STATUS_MAPPING['default']
      end
    end

    def response_successful?(response)
      response.status == HTTP_OK_CODE
    end
  end
end
