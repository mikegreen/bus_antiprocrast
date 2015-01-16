require 'mixlib/config'

module BaConfig
  extend Mixlib::Config
end

BaConfig.from_file(File.join(File.dirname(__FILE__), 'prod.config'))
