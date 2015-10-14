desc 'Execute tests on iOS Simulator'

task :ios do
  ENV['PLATFORM'] = task.name.gsub(':', '_')

  exec "rspec"
end
