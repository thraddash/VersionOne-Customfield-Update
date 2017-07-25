#!/usr/bin/env ruby

require 'shellwords'
require 'yaml'
require 'nokogiri'
require 'open-uri'
require 'rest-client'

require './lib/v1defect'

if File.file?('./config/v1config.yml')
  v1 = V1Connect.new()
  v1.get_defect

end
