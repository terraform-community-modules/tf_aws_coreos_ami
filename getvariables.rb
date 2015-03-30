#!/usr/bin/ruby
require 'net/https'
require 'json'

default = {}

['stable', 'alpha', 'beta'].each do |channel|
  uri = URI.parse("http://#{channel}.release.core-os.net/amd64-usr/current/coreos_production_ami_all.json")
  http = Net::HTTP.new(uri.host, uri.port)
  request = Net::HTTP::Get.new(uri.request_uri)

  data = JSON.parse(http.request(request).body)['amis']
  data.each do |tuple|
    default["#{channel}-#{tuple['name']}-pv"] = tuple['pv']
    default["#{channel}-#{tuple['name']}-hvm"] = tuple['hvm']
  end
end

output = {
  "variable" => {
    "all_amis" => {
      "description" => "The AMI to use",
      "default" => default
    }
  }
}

puts JSON.pretty_generate(output)

