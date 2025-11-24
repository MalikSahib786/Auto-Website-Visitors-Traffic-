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
