# frozen_string_literal: true

require 'faraday'
require 'oj'
require_relative "fantasticstay_api/version"

module FantasticstayApi
  class Error < StandardError; end
  # Your code goes here...
end

require_relative 'fantasticstay_api/api_exceptions'
require_relative 'fantasticstay_api/http_status_codes'
require_relative 'fantasticstay_api/client'