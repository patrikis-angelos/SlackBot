require 'rubygems'
require 'bundler/setup'
require 'dotenv'
require 'slack-ruby-bot'
Dotenv.load

require_relative '../lib/bot'

PatrickBot.run
