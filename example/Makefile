arpu.csv: arpu.pq arpu_agg.sql
	duckdb --csv --header :memory: < arpu_agg.sql > $@

.PHONY: arpu.csv
