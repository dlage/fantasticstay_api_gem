# frozen_string_literal: true

require 'json'
require 'logger'
require_relative 'api'

module FantasticstayApi
  # Main client class that implements communication with the API
  # global_params:
  # - include_related_objects: int	0-1	0
  # - page: int	positive	1
  # - per_page: int	positive	20
  class Client < API
    def listings(global_params = {})
      response = request(
        http_method: :get,
        endpoint: 'listings',
        params: global_params
      )
      process_response(response, 'listings')
    end

    # FantasticstayApi::Client.new.calendar(38859, '2022-01-01', '2022-07-31')
    def calendar(listing_id, start_date = nil, end_date = nil, filters = {}, global_params = {})
      response = request(
        http_method: :get,
        endpoint: 'calendar',
        params: {
          listing_id: listing_id,
          start_date: start_date,
          end_date: end_date,
          filters: filters.to_json
        }.merge(global_params)
      )
      process_response(response, 'calendar')
    end

    # FantasticstayApi::Client.new.reservations(38859)
    def reservations(listing_id, filters = [], sort = {}, global_params = {})
      response = request(
        http_method: :get,
        endpoint: 'reservations',
        params: {
          listing_id: listing_id,
          filters: filters.to_json,
          sort: sort
        }.merge!(global_params)
      )
      process_response(response, 'reservations')
    end

    def reservation(reservation_id, global_params = {})
      response = request(
        http_method: :get,
        endpoint: sprintf('reservations/%d', reservation_id),
        params: global_params
      )
      process_response(response, 'reservation')
    end

    def guest(guest_id, global_params = {})
      response = request(
        http_method: :get,
        endpoint: sprintf('guests/%d', guest_id),
        params: global_params
      )
      process_response(response, 'guest')
    end

    def integrations(global_params = {})
      response = request(
        http_method: :get,
        endpoint: 'integrations',
        params: global_params
      )
      process_response(response, 'integrations')
    end

    protected

    def process_response(response, model = 'results')
      result = {}
      response.keys.each do |k|
        result[k] = response[k]
        case result[k]
        when Hash
          result[k].transform_keys!(&:to_sym)
        when Array
          result[k].each do |r|
            r.transform_keys!(&:to_sym)
          end
        else
          # Nothing to do with other structures, just leave as-is
        end
      end
      result.transform_keys!(&:to_sym)
      result
    end
  end
end
