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
    system('rake image:collect')
    render :text => "OK"
  end

  private
  def tag_recent_media(tag, *args)
    require "open-uri"
    uri = tag_api_uri(tag, Settings.instagram.access_token)
    uri += to_uri_param(args.pop) if args.last.is_a?(Hash)
    str = open(uri){|data| data.read}
    json = JSON.parse(str)
    Hashie::Mash.new(json)
  end
  
  def tag_api_uri(tag, access_token)
    "https://api.instagram.com/v1/tags/#{tag}/media/recent?access_token=#{access_token}"
  end

  def to_uri_param(hash)
    hash.map{|k,v| "&#{k}=#{v}"}.join
  end

end
