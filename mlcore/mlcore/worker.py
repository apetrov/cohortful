from mlcore.lib.queue import PostgresQueue
from dataclasses import dataclass
from mlcore.app import create_app
import json

def main():
    app = create_app()
    queue = PostgresQueue(app.db, 'default')
    queue.listen()

    for task in queue:
        print(f"Processing task {task.id} with payload: {json.dumps(task.payload)}")
        queue.success(task)

if __name__ == '__main__':
    main()
