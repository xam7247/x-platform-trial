require 'colorize'
require 'pry'

# Require all files within 'objects' directory
Dir.glob(File.join(File.dirname(__FILE__), 'objects', '*.rb'), &method(:require))

require_relative "paths_config"

# PLATFORM should be passed to define the target device / browser for cross-platform tests.
#
# For mobiles, it should be the same as the device_capability file name specified beforehand.
# Ex: PLATFORM=ios_sim
#
# For browsers, it should just be the browser name
# Ex: PLATFORM=firefox
#
# For combination platform tests, it should be a combination separated by "-", since we
# need to instantiate both mobile and browser drivers
# Ex: PLATFORM=combo_ios-firefox

def instantiate_driver
  platform = ENV['PLATFORM']
  puts "Execution platform / device: ".colorize(:cyan) + platform

  case platform
    when /^firefox|chrome|safari/i
      setup_web_browser_driver(platform)
    when /^ios|android/i
      setup_mobile_driver(platform)
    when /^combo/i
      combo = platform.sub('combo_', '').split("-")
      mobile_platform = (combo[0] ||= "ios_sim")
      setup_mobile_driver(mobile_platform)

      browser = (combo[1] ||= "firefox")
      setup_web_browser_driver(browser)

    else
      puts "Unsupported platform specified".colorize(:cyan)
  end

end


# https://github.com/appium/ruby_lib/issues/312
# Appium creates a global $driver variable, due to which 2 instances of appium driver
# can't be created simultaneously. For ex: for iOS & Android

# https://github.com/appium/ruby_lib/issues/280
# Need to create config files with fixed name appium.txt, hence need separation via directories

def setup_mobile_driver(device_name)
  puts "Setting up mobile driver ...".colorize(:cyan)
  require 'appium_lib'

  mobile_platform = device_name.split('_').first
  appium_caps_file = File.join(File.dirname(__FILE__), 'device_caps', "#{device_name}_caps", "appium.txt")

  caps = Appium.load_appium_txt file: appium_caps_file, verbose: true
  caps[:caps][:app] = APP_PATHS["native_#{mobile_platform}_app".to_sym]

  Appium::Driver.new(caps).start_driver
  puts "Appium driver: ".colorize(:cyan), $driver

  Appium.promote_appium_methods BaseUI
end

# Capybara creates a driver, which can be interacted with directly
def setup_web_browser_driver(browser_name)
  puts "Setting up browser driver ...".colorize(:cyan)
  require 'capybara'
  require 'capybara/rspec'
  require 'selenium-webdriver'

  Capybara.default_driver = :selenium
  Capybara.default_max_wait_time = 10

  caps = { browser: browser_name.downcase.to_sym }

  Capybara.register_driver :selenium do |app|
    Capybara::Selenium::Driver.new(app, caps)
  end

  Capybara.app_host = APP_PATHS[:webapp]
  puts "Capybara driver: ".colorize(:cyan), page.driver
end

#_____ Rspec Config _____#
RSpec.configure do |config|

  config.before(:all) do
    instantiate_driver
    @app = TestApp.new
  end
  #
  #config.before(:combo) do
  #  unless ENV['PLATFORM'] =~ /combo/i
  #    raise "A combination of mobile and browser is required for combo tests."
  #  end
  #end

  config.after(:all) do
    $driver.driver_quit if $driver
  end

end

