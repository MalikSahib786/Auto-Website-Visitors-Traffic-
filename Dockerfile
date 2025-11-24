# Use Python slim image
FROM python:3.9-slim

# 1. Install Chrome and ChromeDriver dependencies
RUN apt-get update && apt-get install -y \
    wget \
    gnupg \
    unzip \
    chromium \
    chromium-driver \
    libglib2.0-0 \
    libnss3 \
    libgconf-2-4 \
    libfontconfig1

# 2. Set Environment Variables for Chrome
ENV CHROME_BIN=/usr/bin/chromium
ENV CHROMEDRIVER_PATH=/usr/bin/chromedriver

# 3. Install Python Dependencies
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 4. Copy Code
COPY . .

# 5. Start command (We need to run both API and Worker for this simple example, 
# or use Railway to run them as separate services. 
# For simplicity, we will use a script to start the API)
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8080"]
