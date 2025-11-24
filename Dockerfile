# Use Python 3.9 Slim
FROM python:3.9-slim

# 1. Install System Dependencies
# ADDED 'git' to the list so we can download the tool from GitHub
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
# The 'git' tool installed above allows this step to succeed now
RUN pip install --no-cache-dir -r requirements.txt

# 5. Copy App Code
COPY . .

# 6. Start API
CMD uvicorn main:app --host 0.0.0.0 --port $PORT
