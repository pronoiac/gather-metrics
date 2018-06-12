#!/usr/bin/env ruby

require 'yaml'
require "net/http"
require "net/https"
# require "pry"
require "time"

# read config file
$stderr.puts "reading config file..."
config = YAML.load_file("config.yml")
check_timeout = config["overall"]["timeout"] || 5

timestamp = Time.now.to_i # seconds since epoch
hostname = Socket.gethostname

# gather metrics
results = []
config["checks"].each do |check|
  check_output = `timeout #{check_timeout} herd/#{check["file"]}`
  check_output.each_line do |line|
    key, value = line.chomp.split("=")
    # puts "#{key}|#{value}"
    results << [key, value]
  end
end

# assemble json
json_body_items = []
results.each do |key, value|
  json_body_items << 
          "{\"metric\":\"node.#{key}\",
          \"points\":[[#{timestamp}, #{value}]],
          \"type\":\"gauge\",
          \"host\":\"#{hostname}\",
          \"tags\":[\"environment:test\"]
        }"
end

json_body = "{ \"series\" :\n\t[" +
  json_body_items.join(",\n\t") +
  "]\n}"

puts json_body

# post metrics
uri = URI.parse(config["datadog"]["api_endpoint"])
http = Net::HTTP.new(uri.host, uri.port)
request = Net::HTTP::Post.new(uri.request_uri)
request.body = json_body
request["Content-Type"] = "application/json"
http.request(request)
