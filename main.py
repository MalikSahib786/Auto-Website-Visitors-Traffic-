from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware  # <--- Added Import
from pydantic import BaseModel
from tasks import generate_traffic_task

app = FastAPI()

# --- ADDED CORS CONFIGURATION ---
# This allows any website (including your frontend) to talk to this API.
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allows all origins
    allow_credentials=True,
    allow_methods=["*"],  # Allows all methods (POST, GET, etc.)
    allow_headers=["*"],  # Allows all headers
)
# --------------------------------

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
