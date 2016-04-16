#!/usr/bin/env ruby
require 'erb'
require 'date'
require 'optparse'

ARGV << '-h' if ARGV.empty?

options = {}
OptionParser.new do |opts|
  opts.banner = 'Usage: ./lifecal.rb <birthdate> [options]'
  opts.on('-s', '--stdout', 'Print output to stdout [default]') do |s|
    options[:stdout] = s
  end
  opts.on('-f', '--file FILE', String, 'Render output as html file') do |f|
    options[:file] = f
  end
  opts.on_tail('-h', '--help', 'Show this message') do
    puts opts
    exit
  end
end.parse!

FULLBOX = "\u25a0".encode('utf-8')
EMPTYBOX = "\u25a1".encode('utf-8')
BIRTHDATE = Date.parse(ARGV[0])
TODAY = Date.today
LIFE_YEARS = 90
WEEKS_IN_A_YEAR = 52

def lived?(year, week)
  return 'lived' if TODAY.year - BIRTHDATE.year > year
  if TODAY.year - BIRTHDATE.year == year
    return 'lived' if TODAY.cweek > week
  end
end

def console_out
  WEEKS_IN_A_YEAR.times do |week|
    LIFE_YEARS.times { |year| print lived?(year, week) ? FULLBOX : EMPTYBOX }
    puts
  end
end

def html_out(filename)
  res = ERB.new(File.read('lifecal.html.erb')).result(binding)
  File.open(filename, 'w+') do |f|
    f.write(res)
  end

  puts "#{filename} was generated for #{BIRTHDATE}"
end

console_out if options.empty? || options[:stdout]
html_out(options[:file]) if options[:file]
