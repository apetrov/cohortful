class CreateDataset < Struct.new(:db, :bucket_name)
  def call(id, file_path, feature_column, arpu, arpu_std, cohort_size)
    url =  "s3://#{self.bucket_name}/datasets/#{id}.parquet"
    url = "storage/datasets/#{id}.parquet" 
    self.db.execute(<<-SQL
      COPY (
      SELECT
        #{feature_column} AS cohort,
        #{arpu} AS arpu,
        #{arpu_std} AS arpu_std,
        #{cohort_size} AS cohort_size
      FROM read_csv('#{file_path}', auto_detect=true)
      )
      TO '#{url}'
(FORMAT PARQUET, COMPRESSION ZSTD);
    SQL
    )
    url
  end
end
