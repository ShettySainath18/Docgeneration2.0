
# Use an official Python runtime as a parent image
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install Python dependencies
RUN pip install --no-cache-dir flask sphinx sphinx_rtd_theme

# Install build tools
RUN apt-get update && apt-get install -y make && apt-get clean

# Step 1: Create docs directory and initialize Sphinx
RUN mkdir -p docs && \
    sphinx-quickstart --project="Flask Hello World" --author="Your Name" --release="1.0" --quiet docs

# Step 2: Generate API documentation
RUN sphinx-apidoc -o docs/source . || echo "Skipping apidoc generation due to missing Python modules"

# Step 3: Build the Sphinx documentation
RUN cd docs && make html

# Expose port 5000 for Flask
EXPOSE 5000

# Define the command to run the application
CMD ["python", "app.py"]
