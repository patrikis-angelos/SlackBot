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