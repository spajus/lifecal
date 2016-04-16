#!/usr/bin/env ruby
require 'erb'
require 'date'

if ARGV.empty?
  puts 'Usage: ./lifecal.rb <birthdate>'
  exit 0
end

BIRTHDATE = Date.parse(ARGV[0])
TODAY = Date.today
LIFE_YEARS = 90

def lived?(year, week)
  return 'lived' if TODAY.year - BIRTHDATE.year > year
  if TODAY.year - BIRTHDATE.year == year
    return 'lived' if TODAY.cweek > week
  end
end

res = ERB.new(File.read('lifecal.html.erb')).result(binding)
File.open('lifecal.html', 'w+') do |f|
  f.write(res)
end

puts "lifecal.html was generated for #{BIRTHDATE}"
