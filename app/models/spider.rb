require 'mechanize'

# Create a new instance of Mechanize and grab our page
agent = Mechanize.new
page = agent.get('https://www.chewy.com/b/food-387')


# Find all the links on the page that are contained within
# h1 tags.
#hrefs = doc.css(".student-card a").map { |anchor| anchor["href"] }

product_links = page.links.find_all { |l| l.attributes.parent.name == 'product-holder' }
product_links.shift

# Follow each link and print out its title
product_links.each do |link|
    post = link.click
    doc = post.parser
    p doc.css('a').text
end