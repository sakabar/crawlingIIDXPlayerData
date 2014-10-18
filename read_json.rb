#coding: utf-8

require 'json'

json_file_path = 'cookies.json'

# 読み込んで
json_data = open(json_file_path) do |io|
  JSON.load(io)
end

json_data.each do |json|
  print json["domain"]
  print "\t"
  print json["hostOnly"]
  print "\t"
  print json["path"]
  print "\t"
  print json["httpOnly"]
  print "\t"
  if json["expirationDate"]=""
  print "1414229444"
else print json["expirationDate"]
end
  print "\t"
  print json["name"]
  print "\t"
  print json["value"]
  puts ""
end

