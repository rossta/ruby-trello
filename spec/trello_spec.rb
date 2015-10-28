require 'spec_helper'

include Trello
include Trello::Authorization

describe Trello do

  describe 'self.configure' do
    before do
      Trello.configure do |config|
        config.developer_public_key = 'developer_public_key'
        config.member_token         = 'member_token'
      end
    end

    it 'builds auth policy client uses to make requests' do
      allow(TInternet).to receive(:execute)
      expect(Trello.auth_policy).to receive(:authorize)
      Trello.client.get(:member, {})
    end

    it 'configures basic auth policy' do
      auth_policy = Trello.auth_policy
      expect(auth_policy).to be_a(BasicAuthPolicy)
      expect(auth_policy.developer_public_key).to eq('developer_public_key')
      expect(auth_policy.member_token).to eq('member_token')
    end

    context 'oauth' do
      before do
        Trello.configure do |config|
          config.consumer_key     = 'consumer_key'
          config.consumer_secret  = 'consumer_secret'
          config.oauth_token      = 'oauth_token'
          config.oauth_token_secret     = 'oauth_token_secret'
        end
      end

      it 'configures oauth policy' do
        auth_policy = Trello.auth_policy

        expect(auth_policy).to be_a(OAuthPolicy)
        expect(auth_policy.consumer_key).to eq('consumer_key')
        expect(auth_policy.consumer_secret).to eq('consumer_secret')
        expect(auth_policy.oauth_token).to eq('oauth_token')
        expect(auth_policy.oauth_token_secret).to eq('oauth_token_secret')
      end

      it 'updates auth policy configuration' do
        auth_policy = Trello.auth_policy
        expect(auth_policy.consumer_key).to eq('consumer_key')

        Trello.configure do |config|
          config.consumer_key     = 'new_consumer_key'
          config.consumer_secret  = 'new_consumer_secret'
          config.oauth_token      = 'new_oauth_token'
          config.oauth_token_secret     = nil
        end

        auth_policy = Trello.auth_policy

        expect(auth_policy).to be_a(OAuthPolicy)
        expect(auth_policy.consumer_key).to eq('new_consumer_key')
        expect(auth_policy.consumer_secret).to eq('new_consumer_secret')
        expect(auth_policy.oauth_token).to eq('new_oauth_token')
        expect(auth_policy.oauth_token_secret).to be_nil
      end
    end

    context 'not configured' do
      before do
        Trello.configure
      end

      it { expect(Trello.auth_policy).to be_a(AuthPolicy) }
      it { expect { Trello.client.get(:member) }.to raise_error(Trello::ConfigurationError) }
    end

  end
end
