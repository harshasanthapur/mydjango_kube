# Dockerfile

# Use an official Python runtime as a parent image
FROM python:3.8-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Set the working directory in the container
WORKDIR /app

# Install system dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends gcc libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY requirements.txt /app/
RUN pip install --upgrade pip \
    && pip install -r requirements.txt

# Copy the Django application code to the container
COPY . /app/

# Collect static files
CMD python3 manage.py collectstatic --noinput

# Run Gunicorn
CMD ["gunicorn", "mydjangoapp.wsgi:application", "--bind", "0.0.0.0:8000"]

