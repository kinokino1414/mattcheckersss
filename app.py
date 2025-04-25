
import os
from flask import Flask
from models import db

# create the app
app = Flask(__name__)
app.secret_key = os.environ.get("SESSION_SECRET", "bubble_sheet_scanner_secret")

# configure the database using SQLite
app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///app.db"
app.config['UPLOAD_FOLDER'] = 'uploads'
app.config['MAX_CONTENT_LENGTH'] = 50 * 1024 * 1024  # 50MB max upload size
os.makedirs(app.config['UPLOAD_FOLDER'], exist_ok=True)

# initialize the app with the extension
db.init_app(app)

# Set the demo mode flag
DEMO_MODE = True

with app.app_context():
    db.create_all()

# Import routes after app is initialized to avoid circular imports
from routes import *
