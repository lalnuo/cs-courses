require 'open-uri'
require 'nokogiri'
require 'json'
require 'sinatra'
require './course.rb'

get '/' do
  Course.update_if_needed
  Course.all
end
