"""
Flask Web Application Module.

This module contains a simple Flask web application with basic routes
for demonstration purposes.

:author: Your Name
:version: 1.0
"""

from flask import Flask

app = Flask(__name__)


@app.route('/')
def home():
    """
    Home page route handler.
    
    Serves the main landing page of the application.
    
    :returns: A welcome message string
    :rtype: str
    
    Example:
        When accessed via GET request to '/', returns:
        "Hello, World!"
    """
    return "Hello, World!"  


@app.route('/about')
def about():
    """
    About page route handler.
    
    Serves the about page containing information about the application.
    
    :returns: Information about the application
    :rtype: str
    
    Example:
        When accessed via GET request to '/about', returns:
        "This is the about page."
    """
    return "This is the about page."


if __name__ == '__main__':
    """
    Application entry point.
    
    Runs the Flask development server when the script is executed directly.
    The server runs in debug mode for development purposes.
    """
    app.run(debug=True)

