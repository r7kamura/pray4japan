# PoormansCron

[http://github.com/jugyo/poormans_cron](http://github.com/jugyo/poormans_cron)

## Description

PoormansCron is a poor man's cron.

## Usage

### Create a table

Create a table named 'poormans_crons' as following:

    class CreatePoormansCrons < ActiveRecord::Migration
      def self.up
        create_table :poormans_crons, :force => true do |t|
          t.column :id,           :integer
          t.column :name,         :string
          t.column :in_progress,  :boolean, :default => false
          t.column :interval,     :integer
          t.column :performed_at, :datetime
          t.column :wait_time,    :integer
          t.column :async,        :boolean, :default => false
          t.column :lock_version, :integer, :default => 0
        end
      end

      def self.down
        drop_table :poormans_crons
      end
    end

### Create crons

For example, create crons by migration as following:

    PoormansCron::Cron.create(:name => 'hourly', :interval => 60 * 60)

### Register jobs

For example, write config/initializers/poormans_crons.rb as following:

    PoormansCron::Cron.register_job(:hourly) do
      # do something
    end

### Include module

    class ApplicationController < ActionController::Base
      include PoormansCron
      ...

### Filtering

    PoormansCron.filter do |controller|
      controller.controller_name == "foo" && controller.action_name == "bar"
    end

Copyright (c) 2009 jugyo, released under the MIT license
