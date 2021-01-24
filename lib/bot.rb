module SlackRubyBot
  class Client < Slack::RealTime::Client
    def take_action (action, params)
      action = URI "https://slack.com/api/#{action}"
      send_query(action, params)
    end

    def find_weather(params)
      action = URI 'http://api.openweathermap.org/data/2.5/weather'
      send_query(action, params)
    end

    def send_query(action, params)
      action.query = URI.encode_www_form(params)
      response = Net::HTTP.get_response(action)
    end
  end
end

class PatrickBot < SlackRubyBot::Bot
  command 'hi' do |client, data, _match|
    client.take_action('chat.postMessage', {token: ENV['SLACK_API_TOKEN'], channel: data.channel, text:"Hello"})
  end

  command "weather" do |client, data, _match|
    city = data.text.split(' ')[-1]
    t = client.find_weather({q: city, appid: ENV['WEATHER_TOKEN']})
    client.take_action('chat.postMessage', {token: ENV['SLACK_API_TOKEN'], channel: data.channel, text: t.body})
  end
end

PatrickBot.run