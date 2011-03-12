class MediaController < ApplicationController
  before_filter :auth, :only => :index

  def index
    @images = Instagram.tag_recent_media("prayforjapan")
  end

  def more
    @images = Instagram.tag_recent_media("prayforjapan")
    respond_to do |format|
      format.js { render :partial => "images", :layout => false }
    end
  end

  private
  def auth
    Instagram.configure do |config|
      config.client_id    = Settings.instagram.client_id
      config.access_token = Settings.instagram.access_token
    end
  end
end
