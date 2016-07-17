# generate & symlink sitemap at 0am every day
every 1.day, at: '0am' do
  rake 'generate_sitemap'
end

# refresh all the cached content of crawled pages at 1am everyday
every 1.day, at: '1am' do
  rake 'crawl_and_cache_site'
end
