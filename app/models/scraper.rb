
require 'nokogiri'
require 'open-uri'
#require 'pry' #comment out when running server
require_relative './product.rb' #comment out for running just scraper.rb

class Scraper
	def get_page(chewy_url)
		openhtml = open(chewy_url)
		doc=Nokogiri::HTML(openhtml)
		return doc
	end


	def scrape_chewy
		last_page_number= Integer(self.get_page('https://www.chewy.com/b/food-387').css(".cw-pagination__list-item>a").children[-2].text)

		for pg_number in Array(1..last_page_number) do
			foods_links = self.get_page('https://www.chewy.com/b/food_c387_p'+String(pg_number)).css(".product-holder > a").css('a[href]')
			#binding.pry
			product_urls=[]
			brand_names=[]
			product_names=[]
			foods_links.each do |link|
				url = link.attribute('href').value
				brandname = link.css('strong')[0].children.text
				productname = link.css('.content h2').children[2].text.strip
				#binding.pry
				brand_names << brandname
				product_urls << url
				product_names << productname

			end
			#puts product_urls
			scrape_product_pages(product_urls,brand_names,product_names)
		end
	end
	
	def scrape_product_pages(product_urls,brand_names,product_names)

		ingredients_list=[]
		nutristats_list=[]
		urls_list=[]
		brands_list=[]
		names_list=[]
		index =0
		product_urls.each do |product_url|
			url="http://www.chewy.com#{product_url}"
			begin
			  html=open(url)
			rescue OpenURI::HTTPError => e
			  if e.message == '404 Not Found'
			    nutristats_list << "Not found"
				urls_list << url
				brands_list << "Not found"
				names_list << "Not found"
				ingredients_list << "Not found"
			  else
			    raise e
			  end
			else
			doc= Nokogiri::HTML(html)
			nutristats=doc.css("#Nutritional-Info").children.css('.Content-title ~ p')
			
			nutristats.each do |entry|
				nutristats_list << entry.text
				urls_list << url
				names_list << product_names[index]
				brands_list << brand_names[index]
				end

			ingredients=doc.css('#Nutritional-Info .Ingredients-title ~ p').first(nutristats.length)
			ingredients.each do |entry|
				ingredients_list << entry.text.strip
				end
			index+=1
			end
		end
		information=[ingredients_list,nutristats_list,urls_list,brands_list,names_list]
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
				brand: information[3][index],
				product_name: information[4][index]
				)
		index+=1
		end
		
	end

	def self.refresh_products
   		scrape_product_pages(product_urls,brand_names)
 	end

end

#for debugging
#scrapey=Scraper.new
#scrapey.scrape_chewy
#binding.pry

