
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
		brand_names=[]

		foods_links.each do |link|
			url = link.attribute('href').value
			#binding.pry
			brandname=link.css('strong')[0].children.text
			
			brand_names << brandname
			product_urls << url
		end
		#puts product_urls
		scrape_product_pages(product_urls,brand_names)
	end
	
	def scrape_product_pages(product_urls,brand_names)

		ingredients_list=[]
		nutristats_list=[]
		urls_list=[]
		brands_list=[]
		index =0
		product_urls.each do |product_url|
			url="http://www.chewy.com#{product_url}"
			html=open(url)
			doc= Nokogiri::HTML(html)

			nutristats=doc.css("#Nutritional-Info").children.css('.Content-title ~ p')
			
			nutristats.each do |entry|
				nutristats_list << entry.text
				urls_list << url
				brands_list << brand_names[index]
			end

			ingredients=doc.css('#Nutritional-Info .Ingredients-title ~ p').first(nutristats.length)
			ingredients.each do |entry|
				ingredients_list << entry.text
			end
		index+=1
		end
		information=[ingredients_list,nutristats_list,urls_list,brands_list]
		make_product_list(information)
	end

	def make_product_list(information)
		iterations=information[0].length
		index=0
		until index==iterations
			product_entry=Product.find_or_create_by(
				ingredients: information[0][index],
				caloriespercan: information[1][index],
				url: information[2][index],
				brand: information[3][index]
				)
		index+=1
		end
		
	end

	def self.refresh_products
   		scrape_product_pages(product_urls,brand_names)
 	end

end



