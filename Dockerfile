# CRITICAL FIX: Upgraded to Python 3.11 because the tool requires Python >= 3.10
FROM python:3.11-slim

# 1. Install System Dependencies (Git, Chrome, etc.)
RUN apt-get update && apt-get install -y \
    git \
    wget \
    gnupg \
    unzip \
    chromium \
    chromium-driver \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# 2. Set Environment Variables
ENV CHROME_BIN=/usr/bin/chromium
ENV CHROMEDRIVER_PATH=/usr/bin/chromedriver

# 3. Set work directory
WORKDIR /app

# 4. Install Python Dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# --- BOT INSTALLATION START ---
# 5. Manually clone the tool
RUN git clone https://github.com/nayandas69/auto-website-visitor.git /tmp/bot_repo

# 6. Move files to app directory
RUN cp -r /tmp/bot_repo/* /app/

# 7. Rename the main script so we can import it easily in Python
# The original file is likely named "Auto Website Visitor.py" with spaces
# We rename it to "auto_website_visitor.py"
RUN mv "Auto Website Visitor.py" auto_website_visitor.py || true
# --- BOT INSTALLATION END ---

# 8. Copy YOUR API code (overwriting any conflicts)
COPY . .

# 9. Start API
CMD uvicorn main:app --host 0.0.0.0 --port $PORT
