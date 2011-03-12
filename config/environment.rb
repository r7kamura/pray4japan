# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Pray4japan::Application.initialize!

# Specify sass style
Sass::Plugin.options[:style] = :compressed 
