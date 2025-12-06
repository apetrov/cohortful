class CreateDataset < Struct.new(:datalake)
  def csv_to_parquet(file_path, dataset)
    #url =  "s3://#{self.bucket_name}/datasets/#{id}.parquet"
    url = "#{datalake.prefix}/datasets/#{dataset.id}.parquet"
    query = <<-SQL
      COPY (
      SELECT
        #{dataset.feature_name} AS cohort,
        #{dataset.arpu_name} AS arpu,
        #{dataset.arpu_std_name} AS arpu_std,
        #{dataset.size_name} AS cohort_size
      FROM read_csv('#{file_path}', auto_detect=true)
      )
      TO '#{url}'
(FORMAT PARQUET, COMPRESSION ZSTD);
    SQL

    self.datalake.db.execute(query)
    url
  end
end
