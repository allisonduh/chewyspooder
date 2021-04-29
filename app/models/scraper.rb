#scraper.rb

require 'nokogiri'
require 'open-uri'
require 'pry'
require 'mechanize'

class Scraper

chewy_url='https://www.chewy.com/b/food-387'
openhtml = open(chewy_url)
doc=Nokogiri::HTML(openhtml)

foods_links = doc.css(".product-holder > a").css('a[href]')
#binding.pry
product_urls=[]

foods_links.each do |product|
	url = product.attribute('href').value
	product_urls << url
end
puts product_urls
end


scrape=Scraper.new

