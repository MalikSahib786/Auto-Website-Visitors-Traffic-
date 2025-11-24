import os
from celery import Celery

# Railway provides a REDIS_URL environment variable
redis_url = os.getenv("REDIS_URL", "redis://localhost:6379/0")

celery_app = Celery(
    "traffic_worker",
    broker=redis_url,
    backend=redis_url
)
