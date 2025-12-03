BackgroundJob.connection
BackgroundJob.create(queue: 'default', payload: { name: 'hello'})
puts "Created background job in 'default' queue with payload { name: 'hello' }"
