BackgroundJob.connection
BackgroundJob.create(queue: 'inference', payload: { name: 'hello'})
puts "Created background job in 'inference' queue with payload { name: 'hello' }"
