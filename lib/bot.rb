class WeatherBot < SlackRubyBot::Bot
  help do
    title 'Weather Bot'
    desc 'This bot will report the weather in any city'

    command :weather do
      title 'Weather'
      desc 'Reports the weather in the city you specified'
    end

    command :detailed do
      title 'Detailed'
      desc 'A more detailed weather report for the city you specified' \
           'that includes wind speed, humidity and geographical position'
    end
  end
end
