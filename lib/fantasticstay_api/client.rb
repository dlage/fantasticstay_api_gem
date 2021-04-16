# frozen_string_literal: true

require 'logger'
require_relative 'api'

module FantasticstayApi
  # Main client class that implements communication with the API
  class Client < API
    def listings
      response = request(
        http_method: :get,
        endpoint: 'listings'
      )
      listings = response['listings']
      listings.each do |l|
        l.transform_keys!(&:to_sym)
      end
      total = response['total']
      { listings: listings, total: total }
    end

    def integrations
      response = request(
        http_method: :get,
        endpoint: 'integrations'
      )
      integrations = response['integrations']
      integrations.each do |i|
        i.transform_keys!(&:to_sym)
      end
      total = response['total']
      { integrations: integrations, total: total }
    end
  end
end
