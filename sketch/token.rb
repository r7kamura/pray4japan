#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require "rubygems"
require "sinatra"
require "instagram"

enable :sessions

CALLBACK_URL = "http://localhost:4567/oauth/callback"

Instagram.configure do |config|
  config.client_id      = "227676dd7872413d8eb3b3de6115e073"
  config.client_secret  = "deb0fa886e65461c8d00a00869c2dd43"
end

get "/" do
  '<a href="/oauth/connect">Connect with Instagram</a>'
end

get "/oauth/connect" do
  redirect Instagram.authorize_url(:redirect_uri => CALLBACK_URL)
end

get "/oauth/callback" do
  response = Instagram.get_access_token(params[:code], :redirect_uri => CALLBACK_URL)
  response.access_token
end
