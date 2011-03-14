#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

DEBUG = true
class ImageCollector
  def collect(tag)
    images = nil
    loop do
      max_id = images && images.pagination.next_max_id
      images = tag_recent_media(tag, :count => 150, :max_id => max_id)
      filter_has_latlng!(images)
      images.data.each do |image|
        if save_image(image)
          puts "saved: #{image.image_id}" if DEBUG
        else
          puts "validate or error" if DEBUG
        end
      end
    end
  end

  private
  def save_image(image)
    Image.new(
      :thumb_url => image.images.thumbnail.url,
      :image_url => image.images.standard_resolution.url,
      :link      => image.link,
      :image_id  => image.id,
      :caption   => image.caption && image.caption.text,
      :lat       => image.location.latitude,
      :lng       => image.location.longitude,
      :user      => image.user.username,
      :user_picture_url => image.user.profile_picture
    ).save
  end

  def filter_has_latlng!(images)
    images.data.select!{|image| image.location && image.location.latitude && image.location.longitude}  
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
