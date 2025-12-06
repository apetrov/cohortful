import psycopg
import duckdb
import yaml

class App:
    vault: object = None
    pg: object = None
    duck: object = None

class VaultFile:
    def __init__(self, path='env.yml'):
        with open(path, 'r') as f:
            self._data = yaml.safe_load(f)

    def get(self, key: str) -> str:
        return self._data.get(key, None)

def create_app():
    app = App()
    app.vault = VaultFile('env.yml')
    app.pg =  psycopg.connect(app.vault.get('postgres_url'))
    app.duck = duckdb.connect(database=':memory:')
    app.duck.execute(
        open('duckdb.sql').read()
    )
    return app
