AfterConfiguration do
  $scenarios_run = 0
end

# Logging number of scenarios executed
Around() do |scenario, block|
  start = Time.now
  block.call

  time_taken = Time.now - start
  $scenarios_run += 1
  puts "Scenarios run so far: #{$scenarios_run}"
  puts "[ Time taken: #{time_taken} secs ]"
end