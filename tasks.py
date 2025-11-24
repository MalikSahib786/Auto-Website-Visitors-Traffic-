from worker import celery_app
from auto_website_visitor import Visitor
import logging

# Setup logging
logging.basicConfig(level=logging.INFO)

@celery_app.task(name="generate_traffic_task")
def generate_traffic_task(target_url: str, views: int):
    try:
        logging.info(f"Starting traffic for {target_url} - {views} views")
        
        # Initialize the bot (Headless mode is mandatory for servers)
        bot = Visitor(
            url=target_url,
            views=views,
            background=True,  # Run without GUI
            auto_scroll=True,
            drivers_path="/usr/bin/chromedriver" # Docker specific path
        )
        
        bot.run()
        return {"status": "success", "url": target_url}
    except Exception as e:
        return {"status": "failed", "error": str(e)}
```

**4. `main.py` (The API)**
```python
from fastapi import FastAPI
from pydantic import BaseModel
from tasks import generate_traffic_task

app = FastAPI()

class TrafficRequest(BaseModel):
    url: str
    views: int = 10

@app.post("/api/v1/start")
async def start_traffic(req: TrafficRequest):
    # Send task to Celery Queue
    task = generate_traffic_task.delay(req.url, req.views)
    return {
        "message": "Traffic generation queued",
        "job_id": task.id,
        "target": req.url
    }

@app.get("/")
def read_root():
    return {"status": "System Online"}
