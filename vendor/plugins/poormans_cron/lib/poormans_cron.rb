require 'poormans_cron/cron'
require 'poormans_cron/filter'

module PoormansCron
  def self.included(base)
    base.class_eval do
      after_filter PoormansCron::Filter
    end
  end

  def self.filter(&block)
    @filter_proc = block
  end

  def self.filter_proc
    @filter_proc
  end
end
