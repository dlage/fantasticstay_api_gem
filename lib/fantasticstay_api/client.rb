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
      process_response(response)
    end

    # FantasticstayApi::Client.new.calendar(38859, '2022-01-01', '2022-07-31')
    def calendar(listing_id, start_date = nil, end_date = nil, filters = {}, global_params = {})
      response = request(
        http_method: :get,
        endpoint: 'calendar',
        params: {
          listing_id: listing_id, start_date: start_date, end_date: end_date, filters: filters.to_json
        }.merge(global_params)
      )
      process_response(response)
    end

    def listing(listing_id, global_params = {})
      response = request(
        http_method: :get,
        endpoint: "listings/#{listing_id}",
        params: global_params
      )
      process_response(response)
    end

    # FantasticstayApi::Client.new.reservations(38859)
    def reservations(listing_id, filters = [], sort = { order: 'checkIn', direction: 'desc' }, global_params = {})
      response = request(
        http_method: :get,
        endpoint: 'reservations',
        params: {
          listing_id: listing_id, filters: filters.to_json, sort: sort[:order], direction: sort[:direction]
        }.merge!(global_params),
        cache_ttl: 3600 * 24
      )
      process_response(response)
    end

    def reservation(reservation_id, global_params = {})
      response = request(
        http_method: :get,
        endpoint: "reservations/#{reservation_id}",
        params: global_params
      )
      process_response(response)
    end

    def custom_fields(global_params = {})
      response = request(
        http_method: :get,
        endpoint: "custom_fields",
        params: global_params
      )
      process_response(response)
    end

    def set_custom_field_value(id, value, listing_ids: [], reservation_ids: [], global_params: {})
      response = request(
        http_method: :post,
        endpoint: "custom_fields/set_values",
        params: {
          custom_field_id: id,
          #value: value,
          #listing_ids: listing_ids.to_json,
          #reservation_ids: reservation_ids.to_json
        }.merge!(global_params),
        body: {
          value: value,
          listing_ids: listing_ids,
          reservation_ids: reservation_ids
          # listing_ids: "{\"listing_ids\":[#{listing_ids.join(',')}]}",
          # reservation_ids: "{\"reservation_ids\":[#{reservation_ids.join(',')}]}"
        },
      )
      process_response(response)
    end

    def guest(guest_id, global_params = {})
      response = request(
        http_method: :get,
        endpoint: "guests/#{guest_id}",
        params: global_params,
        cache_ttl: 3600 * 24
      )
      process_response(response)
    end

    def integrations(global_params = {})
      response = request(
        http_method: :get,
        endpoint: 'integrations',
        params: global_params
      )
      process_response(response)
    end

    # FantasticstayApi::Client.new.search(query)
    def search(query, type = nil, global_params = {})
      response = request(
        http_method: :get,
        endpoint: 'search',
        params: { q: query, type: type }.merge!(global_params),
        cache_ttl: 3600 * 24
      )
      process_response(response)
    end

    protected

    def process_response(response)
      result = response
      case result
      when Hash
        result.transform_keys!(&:to_sym)
        result.each_value { |r| process_response(r) }
      when Array
        result.each { |r| process_response(r) }
      end
      result
    end
  end
end
