require 'rubygems'
require 'bundler/setup'
require 'net/http'
require 'json'
require 'dotenv'
Dotenv.load

postSomething = URI "https://slack.com/api/chat.postMessage"
params = {
    token: ENV['SLACK_BOT_TOKEN'],
    channel: '#general',
    text: 'Hello'
}
postSomething.query = URI.encode_www_form(params)
res = Net::HTTP.get_response(postSomething)

puts JSON.pretty_generate(JSON.parse(res.body))

uri = URI.parse("https://slack.com/api/apps.connections.open")
request = Net::HTTP::Post.new(uri)
request.content_type = "application/x-www-form-urlencoded"
request["Authorization"] = "Bearer #{ENV['SLACK_APP_TOKEN']}"

req_options = {
  use_ssl: uri.scheme == "https",
}

response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
  http.request(request)
end

response = JSON.parse(response.body)
puts response['url']
