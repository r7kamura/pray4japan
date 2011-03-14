class MediaController < ApplicationController
  def index
    options = {:count => 20}
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

  def map
    @images_with_location = Image.find(:all, :limit => 50, :order => 'created_at DESC')
    render :content_type => 'text/javascript', :layout => false
  end

  def collect
    require "ImageCollector"
    ImageCollector.new.collect("playforjapan")
  end

  private
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
