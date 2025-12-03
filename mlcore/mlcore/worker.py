from mlcore.lib.queue import PostgresQueue
from dataclasses import dataclass
import psycopg

class App:
    db: object = None

def create_app():
    app = App()
    app.db =  psycopg.connect("postgresql://postgres:postgres@localhost/cohortful_development")
    return app


def main():
    app = create_app()
    queue = PostgresQueue(app.db, 'default')
    queue.listen()

    while True:
        task = queue.pop()
        if task:
            print(f"Processing task {task.id} with payload: {json.dumps(task.payload)}")
            # Simulate task processing
            queue.push(task)
        else:
            print("No tasks available, waiting...")
            time.sleep(5)

if __name__ == '__main__':
    main()
