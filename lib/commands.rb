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
                     "Detailed Report for #{weather[:name]}" \
                       "\nLongitude: #{weather[:lon]}, Latitude: #{weather[:lat]}" \
                       "\nThe temperature is #{weather[:temp]}C with #{weather[:desc]}" \
                       "\nHumidity: #{weather[:humidity]}%, Wind speed: #{weather[:speed]}"
                   else
                     "Sorry I could't find \"#{city}\""
                   end
    params = { token: ENV['SLACK_API_TOKEN'], channel: data.channel, text: weather_text, as_user: true }
    client.take_action('chat.postMessage', params)
  end
end