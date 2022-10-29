# frozen_string_literal: true

require 'spec_helper'

RSpec.describe FantasticstayApi, 'search' do
  describe 'search method' do
    let(:request_path) { '/search?q=Dinis&type' }
    let(:body) { fixture('search.json') }
    let(:status) { 200 }

    before do
      stub_get(request_path).to_return(body: body, status: status)
    end

    search_term = 'Dinis'
    search_types = %i[guests integrations listings reservations]

    let(:search_response) { FantasticstayApi::Client.new.search(search_term) }

    it 'returns an hash with all information found' do
      expect(search_response).to be_kind_of(Hash)
      expect(search_response).to have_key(:success)
    end

    search_types.each do |search_type|
      it "#{search_type} returns an array" do
        expect(search_response).to be_kind_of(Hash)
        expect(search_response).to have_key(search_type)
        expect(search_response[search_type]).to be_kind_of(Array)
      end
    end
  end
end
