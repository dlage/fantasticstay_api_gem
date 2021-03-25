# frozen_string_literal: true

RSpec.describe FantasticstayApi do
  it "has a version number" do
    expect(FantasticstayApi::VERSION).not_to be nil
  end

  it "Client initialized" do
    FantasticstayApi::Client.new("test_token")
  end
end
