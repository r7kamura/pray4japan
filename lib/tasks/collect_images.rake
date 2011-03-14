#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require "ImageCollector"

tag = "prayforjapan"
namespace :image do
  desc "Collect images tagged with 'prayforjapan'"
  task :collect => :environment do
    ImageCollector.new.collect(tag)
  end
end
