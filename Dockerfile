# Step 1: Build the Python environment
FROM python:3.12-slim AS build

# Set environment variables to prevent .pyc files and to ensure output is visible
ENV PYTHONUNBUFFERED 1
ENV PYTHONDONTWRITEBYTECODE 1

# Set the working directory in the container
WORKDIR /app

# Install system dependencies for PostgreSQL client (if needed) and other necessary utilities
RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Step 2: Install the Python dependencies
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

# Step 3: Copy the Django project files into the container
COPY . /app/

# Step 4: Run collectstatic to gather static files
RUN python manage.py collectstatic --noinput

# Step 5: Expose necessary ports (8000 for Gunicorn)
EXPOSE 8000

# Step 6: Make sure gunicorn is installed and use it to run the application
RUN pip install gunicorn

# Step 7: Start the application with Gunicorn
CMD ["gunicorn", "ecommerce.wsgi:application", "--bind", "0.0.0.0:8000", "--workers", "3"]
