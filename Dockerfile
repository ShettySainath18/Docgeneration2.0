
# Step 1: Use an official Python base image
FROM python:3.9-slim

# Step 2: Set the working directory inside the container
WORKDIR /app

# Step 3: Copy all project files into the container
COPY . /app

# Step 4: Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Step 5: Set up Sphinx documentation
RUN mkdir -p docs && \
    sphinx-quickstart --project="Flask Hello World" --author="Your Name" --release="1.0" --quiet docs && \
    sphinx-apidoc -o docs/source . && \
    cd docs && make html

# Step 6: Expose a port for Flask
EXPOSE 5000

# Step 7: Run the Flask application
CMD ["python", "app.py"]
