from dataclasses import dataclass
import json
import pandas as pd

from mlcore.models.cohort_arpu import CohortARPUModel
from mlcore.lib.queue import PostgresQueue
from mlcore.app import create_app


df_agg = pd.DataFrame({
    'cohort': ['app1', 'app2', 'app3', 'app4', 'app5'],
    'installs': [  325, 430, 280, 190, 500],
    'arpu': [0.15, 0.22, 0.30, 0.25, 0.05],
    'revenue_sd': [0.48, 0.46, 0.55, 0.50, 0.20],
})

def process_task(app, task, queue):
    print(f"Processing task {task.id} with payload: {json.dumps(task.payload)}")
    try:
        df_agg = app.duck.execute(
            f"""
            SELECT *
            FROM read_parquet('{task.payload['url']}')
            """
        ).df()
        model = CohortARPUModel()
        model.fit(df_agg)
        if 'webhook_url' in task.payload:
            requests.post(
                task.payload['webhook_url'],
                json={'status': 'completed', 'task_id': task.id, 'payload': task.payload}
            )
        queue.success(task)
        return True
    except Exception as e:
        queue.fail(task)
        return False


def main():
    app = create_app()
    queue = PostgresQueue(app.pg, 'inference')
    for task in queue:
        process_task(app, task, queue)

if __name__ == '__main__':
    main()
