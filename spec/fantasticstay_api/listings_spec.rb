# frozen_string_literal: true

require 'spec_helper'

RSpec.describe FantasticstayApi, 'listings' do
  describe 'listings' do
    let(:request_path) { '/listings' }
    let(:body) { fixture('listings.json') }
    let(:status) { 200 }

    before do
      stub_get(request_path).to_return(body: body, status: status)
    end

    let(:listings_response) { FantasticstayApi::Client.new.listings }
    it 'returns correctly some data', :vcr do
      expect(listings_response).to be_kind_of(Hash)
      expect(listings_response).to have_key(:total)
      expect(listings_response).to have_key(:listings)
      expect(listings_response[:listings]).to be_kind_of(Array)
    end
    it 'each listing has basic information', :vcr do
      listings_response[:listings].each do |l|
        expect(l).to have_key(:id)
        expect(l).to have_key(:channel_listing_id)
        expect(l).to have_key(:listing_type)
        expect(l).to have_key(:name)
        expect(l).to have_key(:lat)
        expect(l).to have_key(:lng)
      end
    end
  end
end
