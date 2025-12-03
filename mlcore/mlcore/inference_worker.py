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

def main():
    app = create_app()
    queue = PostgresQueue(app.pg, 'inference')
    for task in queue:
        print(f"Processing task {task.id} with payload: {json.dumps(task.payload)}")
        model = CohortARPUModel()
        model.fit(df_agg)
        queue.success(task)

if __name__ == '__main__':
    main()
