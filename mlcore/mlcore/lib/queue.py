from dataclasses import dataclass
import time

@dataclass
class Task:
    id: int
    payload: object
    attempts: int

"""
    create_table :background_jobs do |t|
      t.string :queue
      t.jsonb :payload
      t.string :status
      t.integer :attempts

      t.timestamps
    end
"""

@dataclass
class QueueContext:
    conn: object
    queue_name: str
    channel: str

    def pop(self):
        with self.conn.cursor() as cursor:
            cursor.execute(
                """
                SELECT id, payload, attempts FROM background_jobs
                WHERE queue = %s and status = %s
                ORDER BY id LIMIT 1 FOR UPDATE SKIP LOCKED
                """,
                (self.queue_name, 'pending')
            )
            row = cursor.fetchone()
            if row:
                task_id, payload, attempts = row
                self._set_status(cursor, task_id, 'processing')
                return Task(task_id, payload, attempts)
        return None

    def push(self, task):
        with self.conn.cursor() as cursor:
            self._set_status(cursor, task.id, 'pending')
            self.cursor.execute("NOTIFY %s, %s", (f"job_{self.queue_name}", str(task.id)))

    def _set_status(self, cursor, task_id, status):
        cursor.execute(
            "UPDATE background_jobs SET status = %s WHERE id = %s",
            (status, task_id)
        )

class PostgresQueue:
    def __init__(self, conn, queue, max_attempts=5):
        self.conn = conn
        self.queue = queue
        self.max_attempts = max_attempts
        self.context = QueueContext(conn, queue, self.channel)

    def __iter__(self):
        self.listen()
        while True:
            yield self.pop()

    @property
    def channel(self):
        return f"job_{self.queue}"

    def pop(self):
        while True:
            # notify = next(self.notifies_gen)
            task = self.context.pop()
            if task:
                return task
            time.sleep(5)

    def success(self, task):
        self._drop(task.id)
        self.conn.commit()

    def fail(self, task):
        if task.attempts >= self.max_attempts:
            self._drop(task.id)
        else:
            self.conn.execute(
                "UPDATE background_jobs SET attempts = attempts + 1  WHERE id = %s",
                (task.id, )
            )
            self.context.push(task)
        self.conn.commit()

    def listen(self):
        pass
        # cur = self.conn.cursor()
        # cur.execute(f"LISTEN {self.channel};")
        # self.notifies_gen = self.conn.notifies()
        # print(f"Worker listening on channel: {self.channel}")

    def _drop(self, task_id):
        self.conn.execute(
            "DELETE FROM background_jobs WHERE id = %s", (task_id,)
        )

class InMemoryQueue:
    def __init__(self):
        self.tasks = []
        self.id_seq = 0

    def listen(self): pass

    def __iter__(self):
        while True:
            task = self.pop()
            if task:
                yield task
            else:
                time.sleep(1)

    def pop(self):
        if self.tasks:
            return self.tasks.pop(0)
        return None

    def success(self, task):
        print(f"Task {task.id} completed successfully.")

    def fail(self, task):
        if task.attempts >= 5:
            print(f"Task {task.id} failed after maximum attempts.")
        else:
            task.attempts += 1
            self.tasks.append(task)
