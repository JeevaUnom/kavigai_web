from datetime import datetime
import re
from flask import Flask, jsonify, request
from flask_sqlalchemy import SQLAlchemy
from flask_cors import CORS
from sqlalchemy import Integer, Numeric

app = Flask(__name__)
CORS(app, resources={r"/api/*": {"origins": "*"}})

app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://postgres:jeeva@localhost/kavigai'
db = SQLAlchemy(app)

class Goals(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(255), nullable=False)
    description = db.Column(db.Text, nullable=False)
    begin_date = db.Column(db.Date, nullable=False)
    end_date = db.Column(db.Date, nullable=False)
    url = db.Column(db.String(255), nullable=True)
    status = db.Column(db.String(50), nullable=False, default='New')

class User(db.Model):
    id = db.Column('user_id', db.Integer, primary_key=True)
    username = db.Column('username', db.String(100), nullable=False)
    email = db.Column('email', db.String(100), nullable=False, unique=True)
    password = db.Column('password', db.String(100), nullable=False)
    
class Book(db.Model):
    __tablename__ = 'books'

    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(255), nullable=False)
    author = db.Column(db.String(255), nullable=False)
    image_url = db.Column(db.String(255))
    genre = db.Column(db.String(100))
    number_of_pages = db.Column(db.Integer)
    publication_date = db.Column(db.String(255), nullable=False) 
    ratings = db.Column(db.Numeric(3, 2))  
    number_of_people_rates = db.Column(db.Integer)  
    description = db.Column(db.Text)

    def __repr__(self):
        return f'<Book {self.id}: {self.title} by {self.author}>'

# Get all goals
@app.route('/api/goals', methods=['GET'])
def get_goals():
    goals = Goals.query.all()
    goals_list = []
    for goal in goals:
        goals_list.append({
            'id': goal.id,
            'name': goal.name,
            'description': goal.description,
            'begin_date': goal.begin_date.strftime('%Y-%m-%d'),
            'end_date': goal.end_date.strftime('%Y-%m-%d'),
            'url': goal.url,
            'status': goal.status
        })
    return jsonify({'goals': goals_list})

# Get a single goal by ID
@app.route('/api/goals/<int:id>', methods=['GET'])
def get_goal(id):
    goal = Goals.query.get(id)
    if goal is None:
        return jsonify({'message': 'Goal not found'}), 404
    
    return jsonify({
        'id': goal.id,
        'name': goal.name,
        'description': goal.description,
        'begin_date': goal.begin_date.strftime('%Y-%m-%d'),
        'end_date': goal.end_date.strftime('%Y-%m-%d'),
        'url': goal.url,
        'status': goal.status
    })

# Create a new goal
@app.route('/api/goals', methods=['POST'])
def create_goal():
    data = request.json
    # Extract data from request
    name = data.get('name')
    description = data.get('description')
    begin_date_str = data.get('begin_date')
    end_date_str = data.get('end_date')
    url = data.get('url')
    status = data.get('status', 'New')

    # Validate data
    if not name or not description or not begin_date_str or not end_date_str:
        return jsonify({'message': 'Name, description, begin_date, and end_date are required'}), 400

    try:
        # Convert dates to datetime objects
        begin_date = datetime.strptime(begin_date_str, '%Y-%m-%d').date()
        end_date = datetime.strptime(end_date_str, '%Y-%m-%d').date()
    except ValueError:
        return jsonify({'message': 'Invalid date format. Please use YYYY-MM-DD'}), 400

    # Create new goal object
    goal = Goals(
        name=name,
        description=description,
        begin_date=begin_date,
        end_date=end_date,
        url=url,
        status=status
    )

    # Add new goal to database
    db.session.add(goal)
    db.session.commit()

    return jsonify({'message': 'Goal created successfully'}), 201

# Update an existing goal
@app.route('/api/goals/<int:id>', methods=['PUT'])
def update_goal(id):
    data = request.json
    # Get the existing goal
    goal = Goals.query.get(id)
    if goal is None:
        return jsonify({'message': 'Goal not found'}), 404

    # Update the goal properties
    goal.name = data.get('name', goal.name)
    goal.description = data.get('description', goal.description)
    goal.begin_date = datetime.strptime(data.get('begin_date', str(goal.begin_date)), '%Y-%m-%d').date()
    goal.end_date = datetime.strptime(data.get('end_date', str(goal.end_date)), '%Y-%m-%d').date()
    goal.url = data.get('url', goal.url)
    goal.status = data.get('status', goal.status)

    # Commit changes to the database
    db.session.commit()

    return jsonify({'message': 'Goal updated successfully'}), 200

# Delete an existing goal
@app.route('/api/goals/<int:id>', methods=['DELETE'])
def delete_goal(id):
    # Get the goal to delete
    goal = Goals.query.get(id)
    if goal is None:
        return jsonify({'message': 'Goal not found'}), 404

    # Delete the goal from the database
    db.session.delete(goal)
    db.session.commit()

    return jsonify({'message': 'Goal deleted successfully'}), 200
# Route to fetch all books

@app.route('/api/books', methods=['GET'])
def get_all_books():
    # Query all books from the database
    books = Book.query.all()

    # Create a list to store book details
    books_list = []
    for book in books:
        books_list.append({
            'id': book.id,
            'title': book.title,
            'author': book.author,
            'image_url': book.image_url,
            'genre': book.genre,
            'number_of_pages': book.number_of_pages,
            'publication_date': book.publication_date,  # Displaying publication date as it is
            'ratings': book.ratings,
            'number_of_people_rates': book.number_of_people_rates,
            'description': book.description
        })

    # Return list of books in JSON format
    return jsonify({'books': books_list})
if __name__ == '__main__':
    app.run(debug=True)
