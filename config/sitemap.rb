# config/sitemap.rb

front_end_url = "seo-frontend.jameshuynh.com"

host front_end_url

sitemap :site do
  url "http://#{front_end_url}/", last_mod: Time.now, change_freq: "daily", priority: 1.0
  url "http://#{front_end_url}/users", priority: 0.95
  url "http://#{front_end_url}/users/", priority: 0.95
end

sitemap_for User.all, name: :user do |user|
  url "http://#{front_end_url}/users/#{user.id}",
      last_mod: user.updated_at,
      priority: 0.95
end

ping_with "#{front_end_url}/sitemap.xml"
