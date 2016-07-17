## lib/tasks/crawl_and_cache_site.rake

require 'sitemap_reader'

task :crawl_and_cache_site => :environment do
  sitemap_reader = SitemapReader.new
  sitemap_reader.urls.each do |url|
    connection = Redis.new(:url => "redis://127.0.0.1/12")
    redis = Redis::Namespace.new(:seo, :redis => connection)
    fullpath = url.gsub('http://seo-frontend.jameshuynh.com', '')

    response = %x{ phantomjs --ssl-protocol=any #{Rails.root}/lib/phantomjs-crawler.js #{url} }
    redis.set(fullpath, response)
  end
end
