#!/usr/bin/env ruby

require "rubygems"
require "json"
require "mysql"

tasks = [
  "import_patients.sql",
  "import_art_visit_encounters.sql",
  "import_first_visit_encounters.sql",
  "import_give_drugs.sql",
  "import_hiv_reception.sql",
  "import_hiv_staging_encounters.sql",
  "import_pre_art_visit_encounters.sql",
  "import_outcome_encounters.sql"
]

def colorize(text, color_code)
  "\e[#{color_code}m#{text}\e[0m"
end

def red(text); colorize(text, 31); end
def green(text); colorize(text, 32); end
def yellow(text); colorize(text, 33); end
def blue(text); colorize(text, 34); end
def magenta(text); colorize(text, 35); end
def cyan(text); colorize(text, 36); end

system("clear")

puts ""
print green("\tEnter MySQL username: ")

$username = gets.chomp

system("clear")

`stty -echo`
puts ""
print green("\tEnter MySQL password: ")

$password = gets.chomp
`stty echo`

system("clear")

puts ""
print green("\tEnter Source Database Name: ")

$src_database = gets.chomp

system("clear")

puts ""
print green("\tEnter Target Destination Name: ")

$dst_database = gets.chomp

system("clear")

if !File.exists?("tmp")
  Dir.mkdir("tmp")
else
  Dir.foreach("tmp").each{|f|
    File.delete("tmp/#{f}") if f != '.' && f != '..'
  }
end

tasks.each do |file|
  f = File.open(file, "r")

  text = f.read

  f.close

  new_text = text.gsub(/bart1\_intermediate\_bare\_bones/i, $src_database)

  dst = File.open("tmp/~#{file}", "w")

  dst.write(new_text)

  dst.close

  system("mysql -u #{$username} -p#{$password} #{$dst_database} < tmp/~#{file}")
  
end

Dir.foreach("tmp").each{|f|
  File.delete("tmp/#{f}") if f != '.' && f != '..'
}

Dir.rmdir("tmp")

