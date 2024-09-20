require 'mixlib/config'

# Module BaConfig is used to manage configuration settings for the application.
# It uses Mixlib::Config for loading and accessing configuration parameters.
module BaConfig
  extend Mixlib::Config

  # Load configuration settings from a file named 'prod.config' located in the same directory as this file.
  # This allows the application to access configuration parameters such as API tokens and other settings defined in 'prod.config'.
  BaConfig.from_file(File.join(File.dirname(__FILE__), 'prod.config'))
end