# lib/tasks/generate_sitemap.rake

task :generate_sitemap => :environment do
  Rake::Task["sitemap:generate"].invoke
  %x{ ln -nfs #{Rails.root}/public/sitemaps/sitemap.xml #{Rails.root}/public/sitemap.xml}
  %x{ ln -nfs #{Rails.root}/public/sitemaps/sitemap.xml #{Rails.root.to_s.gsub('backend', 'frontend').gsub(/releases\/\d+/, 'current')}/public/sitemap.xml}
  %x{ ln -nfs #{Rails.root}/public/sitemaps #{Rails.root.to_s.gsub('backend', 'frontend').gsub(/releases\/\d+/, 'current')}/public/sitemaps}
end
