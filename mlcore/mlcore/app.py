import psycopg

class App:
    db: object = None

def create_app():
    app = App()
    app.db =  psycopg.connect("postgresql://postgres:postgres@localhost/cohortful_development")
    return app
