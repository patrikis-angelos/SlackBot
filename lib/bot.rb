module SlackRubyBot
  class Client < Slack::RealTime::Client
    def take_action(action, params)
      action = URI "https://slack.com/api/#{action}"
      send_query(action, params)
    end

    def find_weather(city)
      action = URI 'http://api.openweathermap.org/data/2.5/weather'
      weather_body = send_query(action, { q: city, appid: ENV['WEATHER_TOKEN'] })
      weather_body = JSON.parse(weather_body.body)
      response_code = weather_body['cod']
      if response_code != 200
        false
      else
        {
          lon: weather_body['coord']['lon'],
          lat: weather_body['coord']['lat'],
          desc: weather_body['weather'][0]['description'],
          temp: (weather_body['main']['temp'] - 273).round,
          name: weather_body['name'],
          humidity: weather_body['main']['humidity'],
          speed: weather_body['wind']['speed']
        }
      end
    end

    def send_query(action, params)
      action.query = URI.encode_www_form(params)
      Net::HTTP.get_response(action)
    end
  end
end

class Commands < SlackRubyBot::Commands::Base
  command 'hi' do |client, data, _match|
    client.take_action('chat.postMessage',
                       { token: ENV['SLACK_API_TOKEN'], channel: data.channel, text: 'Hello', as_user: true })
  end

  command 'weather' do |client, data, _match|
    city = data.text =~ /@/ ? data.text.split(' ', 3)[-1] : data.text.split(' ', 2)[-1]
    weather = client.find_weather(city)
    weather_text = if weather
                     "the temperature in #{weather[:name]} is #{weather[:temp]} C with #{weather[:desc]}"
                   else
                     "Sorry I could't find \"#{city}\""
                   end
    client.take_action('chat.postMessage',
                       { token: ENV['SLACK_API_TOKEN'], channel: data.channel, text: weather_text, as_user: true })
  end

  command 'detailed' do |client, data, _match|
    city = data.text =~ /@/ ? data.text.split(' ', 3)[-1] : data.text.split(' ', 2)[-1]
    weather = client.find_weather(city)
    weather_text = if weather
                     "Detailed Report for #{weather[:name]}" +
                     "\nLongitude: #{weather[:lon]}, Latitude: #{weather[:lat]}" +
                     "\nThe temperature is #{weather[:temp]}C with #{weather[:desc]}" +
                     "\nHumidity: #{weather[:humidity]}%, Wind speed: #{weather[:speed]}"
                   else
                     "Sorry I could't find \"#{city}\""
                   end
    params = { token: ENV['SLACK_API_TOKEN'], channel: data.channel, text: weather_text, as_user: true }
    client.take_action('chat.postMessage', params)
  end
end

class PatrickBot < SlackRubyBot::Bot
  help do
    title 'Weather Bot'
    desc 'This bot will report the weather in any city'

    command :weather do
      title 'Weather'
      desc 'Reports the weather in the city you specified'
    end

    command :detailed do
      title 'Detailed'
      desc "A more detailed weather report for the city you specified" + 
      "that includes wind speed, humidity and geographical position"
    end
  end
end
