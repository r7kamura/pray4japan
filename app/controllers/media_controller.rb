class MediaController < ApplicationController
  before_filter :auth, :only => :index

  def index
    @medias = Instagram.tag_recent_media("prayforjapan")
  end

  private
  # Instagram Authentication
  def auth
    Instagram.configure do |config|
      config.client_id    = Settings.instagram.client_id
      config.access_token = Settings.instagram.access_token
    end
  end
end
