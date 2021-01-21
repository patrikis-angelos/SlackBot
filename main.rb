require 'rubygems'
require 'bundler/setup'
require 'net/http'
require 'json'

uri = URI "https://slack.com/api/chat.postMessage"
params = {
    token: ENV['SLACK_API_TOKEN'],
    channel: '#general',
    text: 'Hello World'
}
uri.query = URI.encode_www_form(params)
res = Net::HTTP.get_response(uri)


puts JSON.pretty_generate(JSON.parse(res.body))