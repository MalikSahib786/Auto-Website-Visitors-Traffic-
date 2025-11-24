# Use Python 3.9 Slim (Debian Bookworm based)
FROM python:3.9-slim

# 1. Install System Dependencies (Chrome & Drivers)
# We removed the old libraries (libgconf) causing the error.
# Installing 'chromium' automatically pulls the right dependencies now.
RUN apt-get update && apt-get install -y \
    wget \
    gnupg \
    unzip \
    chromium \
    chromium-driver \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# 2. Set Environment Variables so Python can find Chrome
ENV CHROME_BIN=/usr/bin/chromium
ENV CHROMEDRIVER_PATH=/usr/bin/chromedriver

# 3. Set the working directory
WORKDIR /app

# 4. Copy requirements and install Python packages
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 5. Copy the rest of the application code
COPY . .

# 6. Start the API using the PORT variable provided by Railway
CMD uvicorn main:app --host 0.0.0.0 --port $PORT
