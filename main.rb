require 'rubygems'
require 'bundler/setup'
require 'dotenv'
require 'slack-ruby-bot'
Dotenv.load

def take_action (action, params)
    action = URI "https://slack.com/api/#{action}"
    action.query = URI.encode_www_form(params)
    response = Net::HTTP.get_response(action)
end

class Bot < SlackRubyBot::Bot
    command 'hi' do |_client, data, _match|
        take_action('chat.postMessage', {token: ENV['SLACK_API_TOKEN'], channel: data.channel, text:'Hello'})
    end
end

Bot.run
