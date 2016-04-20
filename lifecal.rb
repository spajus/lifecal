#!/usr/bin/env ruby
require 'erb'
require 'date'
require 'optparse'

ARGV << '-h' if ARGV.empty?

OPTIONS = { granularity: :weeks }
OptionParser.new do |opts|
  opts.banner = 'Usage: ./lifecal.rb <birthdate> [options]'
  opts.on('-s', '--stdout', 'Print output to stdout [default]') do |s|
    OPTIONS[:stdout] = s
  end
  opts.on('-f', '--file FILE', String, 'Render output as html file') do |f|
    OPTIONS[:file] = f
  end
  opts.on('-g' '--granularity [GRANULARITY]', [:weeks, :months],
          'Select time granularity (weeks, months), default: weeks') do |t|
    OPTIONS[:granularity] = t
  end
  opts.on_tail('-h', '--help', 'Show this message') do
    puts opts
    exit
  end
end.parse!

OPTIONS[:stdout] = true unless OPTIONS[:stdout] || OPTIONS[:file]

FULLBOX = "\u25a0".encode('utf-8')
EMPTYBOX = "\u25a1".encode('utf-8')
BIRTHDATE = Date.parse(ARGV[0])
TODAY = Date.today
LIFE_YEARS = 90

GRANULARITY = {
  weeks: 52,
  months: 12
}

def lived?(year, num)
  return 'lived' if TODAY.year - BIRTHDATE.year > year
  if TODAY.year - BIRTHDATE.year == year
    return 'lived' if TODAY.send(weeks? ? :cweek : :month)  > num
  end
end

def weeks?
  OPTIONS[:granularity] == :weeks
end

def granularity
  GRANULARITY[OPTIONS[:granularity]]
end

def console_out
  granularity.times do |n|
    LIFE_YEARS.times do |year|
      print lived?(year, n) ? FULLBOX : EMPTYBOX
    end
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

console_out if OPTIONS[:stdout]
html_out(OPTIONS[:file]) if OPTIONS[:file]
