require 'rspec/matchers'
require 'colorize'

if ENV['HEADLESS']
  ENV['UID'] ||= 'headless'
end

World() do
  TestApp.new
end
