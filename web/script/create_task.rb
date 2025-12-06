BackgroundJob.connection
BackgroundJob.create(queue: 'inference', payload: {
  dataset_id: 1,
  url: "s3://my-bucket/datasets/1.parquet",
  webhook_url: "https://cohortful.com/webhooks/inference_complete/1"
})
puts "Created background job in 'inference' queue with payload { name: 'hello' }"
