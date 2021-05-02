namespace :chewySpooder do
  namespace :scrapers do
    desc 'Refresh products'
    task refresh: :environment do
      @scrape.refresh_products
    end
  end
end