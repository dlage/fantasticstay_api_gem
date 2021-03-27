# frozen_string_literal: true

module FantasticstayApi
  # Main client class that implements communication with the API
  class Client
    include FantasticstayApi::HttpStatusCodes
    include FantasticstayApi::ApiExceptions

    API_ENDPOINT = "https://api.fsapp.io"
    HTTP_STATUS_MAPPING = {
      HTTP_BAD_REQUEST_CODE => BadRequestError,
      HTTP_UNAUTHORIZED_CODE => UnauthorizedError,
      HTTP_FORBIDDEN_CODE => ForbiddenError,
      HTTP_NOT_FOUND_CODE => NotFoundError,
      HTTP_UNPROCESSABLE_ENTITY_CODE => UnprocessableEntityError,
      "default" => ApiError
    }.freeze
    attr_reader :api_token

    def initialize(api_token = nil)
      @api_token = api_token
    end

    def listings
      request(
        http_method: :get,
        endpoint: "listings"
      )
    end

    private

    def client
      @client ||= Faraday.new(API_ENDPOINT) do |client|
        client.request :url_encoded
        client.adapter Faraday.default_adapter
        client.headers["x-api-key"] = @api_token
      end
    end

    def request(http_method:, endpoint:, params: {})
      response = client.public_send(http_method, endpoint, params)
      parsed_response = Oj.load(response.body)

      return parsed_response if response_successful?(response)

      raise error_class(response), "Code: #{response.status}, response: #{response.body}"
    end

    def error_class(response)
      if HTTP_STATUS_MAPPING.include?(response.status)
        HTTP_STATUS_MAPPING[response.status]
      else
        HTTP_STATUS_MAPPING["default"]
      end
    end

    def response_successful?(response)
      response.status == HTTP_OK_CODE
    end
  end
end
