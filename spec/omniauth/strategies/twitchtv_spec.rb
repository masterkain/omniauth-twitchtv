require 'spec_helper'

describe "OmniAuth::Strategies::Twitchtv" do
  subject do
    OmniAuth::Strategies::Twitchtv.new(nil, @options || {})
  end

  it 'should add a camelization for itself' do
    OmniAuth::Utils.camelize('twitchtv').should == 'Twitchtv'
  end

  context 'client options' do
    it 'has correct Twitchtv site' do
      subject.options.client_options.site.should eq('https://api.twitch.tv')
    end

    it 'has correct authorize url' do
      subject.options.client_options.authorize_url.should eq('https://api.twitch.tv/kraken/oauth2/authorize')
    end
  end

end
