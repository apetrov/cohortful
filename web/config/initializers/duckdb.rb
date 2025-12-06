def create_datalake()
  duckdb = DuckDB::Database.open.connect  # ← This creates :memory: by default
  data_lake = Datalake.new(duckdb, 's3://cohortful-development-v1')
  data_lake.init!
  data_lake
end

Rails.application.config.to_prepare do
  Datalake.instance = create_datalake()
end

