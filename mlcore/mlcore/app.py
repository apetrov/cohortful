import psycopg
import yaml

class App:
    vault: object = None
    db: object = None


class VaultFile:
    def __init__(self, path='env.yml'):
        with open(path, 'r') as f:
            self._data = yaml.safe_load(f)

    def get(self, key: str) -> str:
        return self._data.get(key, None)

def create_app():
    app = App()
    app.vault = VaultFile('env.yml')
    app.db =  psycopg.connect(app.vault.get('postgres_url'))
    return app
