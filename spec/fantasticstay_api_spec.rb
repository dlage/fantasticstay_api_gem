# frozen_string_literal: true

require 'spec_helper'

RSpec.describe FantasticstayApi do
  it 'has a version number' do
    expect(FantasticstayApi::VERSION).not_to be nil
  end

  api_key = 'test_key'
  api_endpoint = 'https://api.fsapp.io'
  api_options = { token: api_key, endpoint: api_endpoint }

  describe 'FantasticstayApi::Client' do
    let(:api_client) { FantasticstayApi.new(api_options) }
    it 'is initialized with options' do
      expect(api_client).to be_a(FantasticstayApi::Client)
      expect(api_client.token).to equal(api_key)
      expect(api_client.endpoint).to equal(api_endpoint)
    end
    let(:default_api_client) { FantasticstayApi.new }
    it 'defaults are initialized as well' do
      expect(api_client).to be_a(FantasticstayApi::Client)
      expect(api_client.token).not_to be_nil
      expect(api_client.endpoint).not_to be_nil
    end
  end
end
