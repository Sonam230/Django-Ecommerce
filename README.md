This guide explains how to containerize your Django project using Docker.

📌 Prerequisites
Docker installed on your system.
A Django project with requirements.txt listing all dependencies.

1️⃣ Create a Dockerfile
Inside your project root directory, create a Dockerfile:

dockerfile

# Use an official Python runtime as the base image
FROM python:3.12

# Set the working directory inside the container
WORKDIR /app

# Copy the current project files into the container
COPY . /app

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Collect static files
RUN python manage.py collectstatic --noinput

# Expose the port Django will run on
EXPOSE 8000

# Start the Gunicorn server
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "myproject.wsgi:application"]
🔹 Replace myproject.wsgi:application with your Django project's WSGI module.

2️⃣ Create a .dockerignore File (Optional)
To prevent unnecessary files from being copied into the container, create .dockerignore:

__pycache__/
*.pyc
*.pyo
*.pyd
db.sqlite3
.env
venv/
node_modules/

3️⃣ Build the Docker Image
Run the following command to build the Docker image:

docker build -t django-app .

4️⃣ Run the Docker Container
To start a container from the image:


docker run -d -p 8000:8000 --name django-container django-app
📌 The -d flag runs the container in the background, and -p 8000:8000 maps port 8000 of the container to port 8000 of your host.

5️⃣ Access the Application
Once the container is running, open your browser and go to:


http://localhost:8000
If running on a remote server, replace localhost with your server's IP address.

6️⃣ Access the Running Container (Optional)
To open a shell inside the container:
docker exec -it django-container /bin/bash

7️⃣ Stop & Remove the Container
To stop the running container:

docker stop django-container
To remove it:
docker rm django-container

8️⃣ Restart the Container
If you make changes and want to restart the container:


docker restart django-container
