
from datetime import datetime
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy.orm import DeclarativeBase

class Base(DeclarativeBase):
    pass

db = SQLAlchemy(model_class=Base)

class Student(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)
    student_id = db.Column(db.String(50), nullable=True)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    
    scans = db.relationship('ScanResult', backref='student', lazy=True)
    
    def __repr__(self):
        return f'<Student {self.name}>'

class Question(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    question_id = db.Column(db.Integer, nullable=False)
    correct_answer = db.Column(db.String(1), nullable=False)
    
    def __repr__(self):
        return f'<Question {self.question_id}: {self.correct_answer}>'

class ScanResult(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    student_id = db.Column(db.Integer, db.ForeignKey('student.id'), nullable=False)
    template_used = db.Column(db.String(50), nullable=False)
    score = db.Column(db.Integer, nullable=False)
    total_questions = db.Column(db.Integer, nullable=False)
    percentage = db.Column(db.Float, nullable=False)
    scan_date = db.Column(db.DateTime, default=datetime.utcnow)
    image_path = db.Column(db.String(255), nullable=True)
    
    answers = db.relationship('Answer', backref='scan_result', lazy=True, cascade="all, delete-orphan")
    
    def __repr__(self):
        return f'<ScanResult {self.id}: {self.score}/{self.total_questions}>'

class Answer(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    scan_result_id = db.Column(db.Integer, db.ForeignKey('scan_result.id'), nullable=False)
    question_number = db.Column(db.Integer, nullable=False)
    selected_answer = db.Column(db.String(1), nullable=True)
    correct_answer = db.Column(db.String(1), nullable=False)
    is_correct = db.Column(db.Boolean, nullable=False)
    
    def __repr__(self):
        return f'<Answer {self.question_number}: {self.selected_answer} (Correct: {self.correct_answer})>'

class Quiz(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(100), nullable=False)
    num_items = db.Column(db.Integer, nullable=False)
    answer_key = db.Column(db.String(100), nullable=False)  # Stores answers as string "ABCDABCD..."
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    
    def __repr__(self):
        return f'<Quiz {self.title}: {self.num_items} items>'
