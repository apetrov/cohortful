DUCKDB = DuckDB::Database.open.connect  # ← This creates :memory: by default
DUCKDB.execute(File.read(Rails.root.join("db", "duckdb.sql")))

# eval db/duckdb.sql



