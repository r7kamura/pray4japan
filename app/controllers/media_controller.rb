class MediaController < ApplicationController
  #before_filter :auth, :only => :index

  def index
    options = {:count => 40}
    options.merge!({:max_id => params[:max_id].to_i}) if params[:max_id]
    res = tag_recent_media("prayforjapan", options)
    @images = res.data
    @max_id = res.pagination.next_max_id
  end

  def more
    index
    respond_to do |format|
      format.js { render :partial => "images", :layout => false, :local => {} }
    end
  end

  private
  def auth
    Instagram.configure do |config|
      config.client_id    = Settings.instagram.client_id
      config.access_token = Settings.instagram.access_token
    end
  end

  def tag_recent_media(tag, *args)
    require "open-uri"
    uri = "https://api.instagram.com/v1/tags/#{tag}/media/recent?"
    uri += "access_token=#{Settings.instagram.access_token}"
    options = args.last.is_a?(Hash) ? args.pop : {}
    options.each do |k, v|
      uri += "&#{k}=#{v}"
    end
    str = open(uri){|data|data.read}
    json = JSON.parse(str)
    Hashie::Mash.new(json)
  end
end
