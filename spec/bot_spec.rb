require 'rubygems'
require 'bundler/setup'
require 'dotenv'
require 'slack-ruby-bot'
Dotenv.load

require_relative '../lib/client'
require_relative '../lib/commands'
require_relative '../lib/bot'

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
      client.find_weather('Athens')
      expect(client.weather.is_a?(Hash)).to eql(true)
    end
    it 'returns false if the town does not exist' do
      weather = client.find_weather('Townton')
      expect(weather).to eql(false)
    end
  end
end

describe Commands do
  let(:client) { SlackRubyBot::Client.new }
  let(:commands) { Commands.new }
  it 'creates the commands that the bot can hear in real time' do
    expect(commands.is_a?(SlackRubyBot::Commands::Base)).to eql(true)
  end
end

describe WeatherBot do
  let(:bot) { WeatherBot.new }
  it 'creates a Slack Ruby bot instance' do
    expect(bot.is_a?(SlackRubyBot::Bot)).to eql(true)
  end
end
