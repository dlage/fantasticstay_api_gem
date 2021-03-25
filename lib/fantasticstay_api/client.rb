module FantasticstayApi
  class Client
    include FantasticstayApi::HttpStatusCodes
    include FantasticstayApi::ApiExceptions

    API_ENDPOINT = 'https://api.fsapp.io'.freeze

    attr_reader :api_token

    def initialize(api_token = nil)
      @api_token = api_token
    end

    def listings()
      request(
        http_method: :get,
        endpoint: "listings"
      )
    end

    private


    def client
      @_client ||= Faraday.new(API_ENDPOINT) do |client|
        client.request :url_encoded
        client.adapter Faraday.default_adapter
        client.headers['x-api-key'] = @api_token
      end
    end

    def request(http_method:, endpoint:, params: {})
      response = client.public_send(http_method, endpoint, params)
      parsed_response = Oj.load(response.body)

      return parsed_response if response_successful?(response)

      raise error_class(response), "Code: #{response.status}, response: #{response.body}"
    end

    def error_class(response)
      case response.status
      when HTTP_BAD_REQUEST_CODE
        BadRequestError
      when HTTP_UNAUTHORIZED_CODE
        UnauthorizedError
      when HTTP_FORBIDDEN_CODE
        ForbiddenError
      when HTTP_NOT_FOUND_CODE
        NotFoundError
      when HTTP_UNPROCESSABLE_ENTITY_CODE
        UnprocessableEntityError
      else
        ApiError
      end
    end

    def response_successful?(response)
      response.status == HTTP_OK_CODE
    end
  end #Client
end #FantasticstayApi