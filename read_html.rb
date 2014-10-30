#coding: utf-8
require 'nokogiri'
require 'kconv'

html_file = ARGV[0]

f = File.open(html_file)
doc = Nokogiri::HTML(f, nil, 'utf-8')
f.close

tables = doc.xpath("//table")
table = tables[2]

table.children.each do |tr|
  tds = tr.children
  href = tr.xpath('./td/a')[0]

  # 11-20 のような、順位を表す行にはリンクは無い
  unless href.nil?
    print href.attribute("href")
    print ","
  end
  tds.each do |td|
    print td.text
    print ","
  end
  puts ""
end
