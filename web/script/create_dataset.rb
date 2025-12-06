file = "/Users/apetrov/projects/cohortful/example/arpu.csv"
cd = CreateDataset.new(Datalake.instance)
dataset = Dataset.new(feature_name: 'app', arpu_name: 'arpu', arpu_std_name: 'revenue_std', size_name: 'n')
dataset.save!
url = cd.csv_to_parquet(file, dataset)
puts url
