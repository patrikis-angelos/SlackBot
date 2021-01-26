class Commands < SlackRubyBot::Commands::Base
  command 'hi' do |client, data, _match|
    client.take_action('chat.postMessage',
                       { token: ENV['SLACK_API_TOKEN'], channel: data.channel, text: 'Hello', as_user: true })
  end

  command 'weather' do |client, data, _match|
    city = data.text =~ /@/ ? data.text.split(' ', 3)[-1] : data.text.split(' ', 2)[-1]
    client.find_weather(city)
    weather_text = if client.weather
                     "the temperature in #{client.weather[:name]} is #{client.weather[:temp]} C with #{client.weather[:desc]}"
                   else
                     "Sorry I could't find \"#{city}\""
                   end
    client.take_action('chat.postMessage',
                       { token: ENV['SLACK_API_TOKEN'], channel: data.channel, text: weather_text, as_user: true })
  end

  command 'detailed' do |client, data, _match|
    city = data.text =~ /@/ ? data.text.split(' ', 3)[-1] : data.text.split(' ', 2)[-1]
    client.find_weather(city)
    weather_text = if client.weather
                     "Detailed Report for #{client.weather[:name]}" \
                       "\nLongitude: #{client.weather[:lon]}, Latitude: #{client.weather[:lat]}" \
                       "\nThe temperature is #{client.weather[:temp]}C with #{client.weather[:desc]}" \
                       "\nHumidity: #{client.weather[:humidity]}%, Wind speed: #{client.weather[:speed]}"
                   else
                     "Sorry I could't find \"#{city}\""
                   end
    params = { token: ENV['SLACK_API_TOKEN'], channel: data.channel, text: weather_text, as_user: true }
    client.take_action('chat.postMessage', params)
  end
end
