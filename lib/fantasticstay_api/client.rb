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
      process_response(response, 'listings')
    end

    # FantasticstayApi::Client.new.calendar(38859, '2022-01-01', '2022-07-31')
    def calendar(listing_id, start_date = nil, end_date = nil, filters = {})
      response = request(
        http_method: :get,
        endpoint: 'calendar',
        params: {
          listing_id: listing_id,
          start_date: start_date,
          end_date: end_date,
          filters: filters
        }
      )
      process_response(response, 'calendar')
    end

    # FantasticstayApi::Client.new.reservations(38859)
    def reservations(listing_id, filters = {}, sort = {})
      response = request(
        http_method: :get,
        endpoint: 'reservations',
        params: {
          listing_id: listing_id,
          filters: filters,
          sort: sort
        }
      )
      process_response(response, 'reservations')
    end

    def integrations
      response = request(
        http_method: :get,
        endpoint: 'integrations'
      )
      process_response(response, 'integrations')
    end

    protected

    def process_response(response, model='results')
      results = response[model]
      results.each do |r|
        r.transform_keys!(&:to_sym)
      end
      total = response['total']
      { model.to_sym => results, total: total }
    end
  end
end
