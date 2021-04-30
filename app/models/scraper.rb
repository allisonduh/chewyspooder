
require 'nokogiri'
require 'open-uri'
#require 'pry'
require_relative './product.rb'

class Scraper
	def get_page
		chewy_url='https://www.chewy.com/b/food-387'
		openhtml = open(chewy_url)
		doc=Nokogiri::HTML(openhtml)
		return doc
	end

	def scrape_chewy
		
		foods_links = self.get_page.css(".product-holder > a").css('a[href]')
		#binding.pry
		product_urls=[]

		foods_links.each do |product|
			url = product.attribute('href').value
			product_urls << url
		end
		#puts product_urls
		@product_urls=product_urls
		scrape_product_pages(product_urls)
	end
	
	def scrape_product_pages(product_urls)

		ingredients_list=[]
		nutristats_list=[]
		urls_list=[]
		product_urls.each do |product_url|
			url="http://www.chewy.com#{product_url}"
			html=open(url)
			doc= Nokogiri::HTML(html)

			nutristats=doc.css("#Nutritional-Info").children.css('.Content-title ~ p')
			
			nutristats.each do |entry|
				nutristats_list << entry.text
				urls_list << url
			end

			ingredients=doc.css('#Nutritional-Info .Ingredients-title ~ p').first(nutristats.length)
			ingredients.each do |entry|
				ingredients_list << entry.text
			end
			
		end
		information=[ingredients_list,nutristats_list,urls_list]
		make_product_list(information)
	end

	def make_product_list(information)
		iterations=information[0].length
		index=0
		until index==iterations
			product_entry=Product.find_or_create_by(
				url: information[2][index],
				caloriespercan: information[1][index],
				ingredients: information[0][index],
				)
		index+=1
		end
		
	end

end
scrape=Scraper.new
scrape.scrape_chewy


