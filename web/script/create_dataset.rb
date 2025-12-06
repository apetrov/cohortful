file = "/Users/apetrov/projects/cohortful/example/arpu.csv"
cd = CreateDataset.new(DUCKDB, 'cohortful-development-v1')
url = cd.call(1, file, 'app', 'arpu', 'revenue_std', 'n')
puts url
