# frozen_string_literal: true

require 'spec_helper'

RSpec.describe FantasticstayApi, 'integrations' do
  let(:request_path) { '/integrations' }
  let(:body) { fixture('integrations.json') }
  let(:status) { 200 }

  before do
    stub_get(request_path).to_return(body: body, status: status)
  end

  let(:integrations_result) { FantasticstayApi::Client.new.integrations }
  it 'returns integrations', :vcr do
    expect(integrations_result).to have_key(:total)
    expect(integrations_result).to have_key(:integrations)
    integrations_result[:integrations].each do |i|
      expect(i).to have_key(:id)
      expect(i).to have_key(:nickname)
      expect(i).to have_key(:picture)
      expect(i).to have_key(:user)
      expect(i).to have_key(:full_name)
    end
  end
end
