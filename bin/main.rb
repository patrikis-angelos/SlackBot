require 'rubygems'
require 'bundler/setup'
require 'dotenv'
require 'slack-ruby-bot'
Dotenv.load

require_relative '../lib/bot'
require_relative '../lib/commands'
require_relative '../lib/client'

Slack.configure do |config|
  config.token = ENV['SLACK_API_TOKEN']
end

WeatherBot.run
