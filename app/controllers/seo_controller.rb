class SeoController < ApplicationController
  layout false

  def content

    # get the path from the request
    frontend_full_path = params[:path]

    ## initialize a redis instance
    connection = Redis.new(:url => "redis://127.0.0.1/12")
    redis = Redis::Namespace.new(:seo, :redis => connection)

    # try to get out the cached content
    html = redis.get(frontend_full_path)
    if html.nil?
      # no cache content - crawl using PhantomJS
      html = crawl_frontend(frontend_full_path)
    end

    # respond back to search engine
    render inline: html
  end

  private

  def crawl_frontend(fullpath)
    # perform a crawl
    response = %x{ phantomjs --ssl-protocol=any #{Rails.root}/lib/phantomjs-crawler.js "http://seo-frontend.jameshuynh.com/#{fullpath}" }

    # initialize a redis instance
    connection = Redis.new(:url => "redis://127.0.0.1/12")
    redis = Redis::Namespace.new(:seo, :redis => connection)

    # store the crawling content using fullpath as the key
    redis.set(fullpath, response)

    return response
  end
end
