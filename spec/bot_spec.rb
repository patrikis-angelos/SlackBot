require 'rubygems'
require 'bundler/setup'
require 'dotenv'
require 'slack-ruby-bot'
Dotenv.load

require_relative '../lib/client'

describe SlackRubyBot::Client do
  let(:client) { SlackRubyBot::Client.new }
  describe '#take_action' do
    it 'constucts a URI, sends the request and returns the response' do
      res = client.take_action('auth.test', token: ENV['SLACK_API_TOKEN'])
      res = JSON.parse(res.body)
      expect(res['ok']).to eql(true)
    end
    it 'returns a negative response if given a non valid token' do
      res = client.take_action('auth.test', token: 'some-non-valid-token')
      res = JSON.parse(res.body)
      expect(res['ok']).not_to eql(true)
    end
  end
  describe '#find_weather' do
    it 'returns the weather in hash for the specified city' do
      weather = client.find_weather('Athens')
      expect(weather.is_a?(Hash)).to eql(true)
    end
    it 'returns false if the town does not exist' do
      weather = client.find_weather('Townton')
      expect(weather).to eql(false)
    end
  end
end
