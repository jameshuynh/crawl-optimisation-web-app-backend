# lib/sitemap_reader.rb

class SitemapReader

  def initialize(config_path="config/sitemap.rb")
    @urls = []
    self.instance_eval(File.open("#{Rails.root}/#{config_path}").read)
  end

  def host(url=nil)
    url
  end

  def sitemap(sym)
    @urls << yield
  end

  def sitemap_for(entities, opts={})
    entities.each do |entity|
      @urls << yield(entity)
    end
  end

  def url(url, opts={})
    url.gsub(/\s/, '')
  end

  def urls
    @urls
  end

  def ping_with(url)
  end

end
