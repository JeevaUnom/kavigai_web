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
    
class Todo(db.Model):
    __tablename__ = 'todo'

    todoId = db.Column('todoid', db.Integer, primary_key=True)
    todoName = db.Column('todoname', db.String(255), nullable=False)
    todoDescription = db.Column('tododescription', db.Text)
    todoBeginDate = db.Column('todobegindate', db.Date, nullable=False)
    todoEndDate = db.Column('todoenddate', db.Date, nullable=False)
    todoStatus = db.Column('todostatus', db.String(50))
    id = db.Column('id', db.Integer, db.ForeignKey('goals.id'), nullable=False, default=1)

    def __repr__(self):
        return f'<Todo {self.todoId}: {self.todoName}>'
    
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

class UserBook(db.Model):
    __tablename__ = 'userbook'
    __table_args__ = {'quote': True}  # Ensure that column names are quoted

    bookId = db.Column('bookid', db.Integer, primary_key=True)
    id = db.Column('id', db.Integer, db.ForeignKey('goals.id'), nullable=False, default=1)
    bookTitle = db.Column('booktitle', db.String(255), nullable=False)
    bookAuthor = db.Column('bookauthor', db.String(255), nullable=False)
    bookDescription = db.Column('bookdescription', db.Text, nullable=False)
    bookPageCount = db.Column('bookpagecount', db.Integer, nullable=False)
    bookGenre = db.Column('bookgenre', db.String(100), nullable=False)
    bookBeginDate = db.Column('bookbegindate', db.Date, nullable=False)
    bookEndDate = db.Column('bookenddate', db.Date, nullable=False)
    bookStatus = db.Column('bookstatus', db.String(50), nullable=False)

class Event(db.Model):
    __tablename__ = 'event'
    __table_args__ = {'quote': True}  # Ensure that column names are quoted

    eventId = db.Column('eventid', db.Integer, primary_key=True)
    id = db.Column('id', db.Integer, db.ForeignKey('goals.id'), nullable=False, default=1)
    eventTitle = db.Column('eventtitle', db.String(255), nullable=False)
    eventDomain = db.Column('eventdomain', db.String(255), nullable=False)
    eventDescription = db.Column('eventdescription', db.Text, nullable=False)
    eventBeginDate = db.Column('eventbegindate', db.DateTime, nullable=False)
    eventEndDate = db.Column('eventenddate', db.DateTime, nullable=False)
    eventLocation = db.Column('eventlocation', db.String(255), nullable=False)
    eventSpeaker = db.Column('eventspeaker', db.String(255), nullable=False)
    eventMode = db.Column('eventmode', db.String(255), nullable=False)
    eventStatus = db.Column('eventstatus', db.String(50), nullable=False)

class Meeting(db.Model):
    __tablename__ = 'meeting'

    meetingId = db.Column('meetingid', db.Integer, primary_key=True)
    id = db.Column('id', db.Integer, db.ForeignKey('goals.id'), nullable=False, default=1)
    meetingTitle = db.Column('meetingtitle', db.String(255), nullable=False)
    meetingBeginDate = db.Column('meetingbegindate', db.DateTime, nullable=False)
    meetingEndDate = db.Column('meetingenddate', db.DateTime, nullable=False)
    meetingDescription = db.Column('meetingdescription', db.Text, nullable=False)
    meetingStatus = db.Column('meetingstatus', db.String(50), nullable=False)

    def __repr__(self):
        return f'<Meeting {self.meetingId}: {self.meetingTitle}>'

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
            'beginDate': goal.begin_date.strftime('%Y-%m-%d'),
            'endDate': goal.end_date.strftime('%Y-%m-%d'),
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
        'beginDate': goal.begin_date.strftime('%Y-%m-%d'),
        'endDate': goal.end_date.strftime('%Y-%m-%d'),
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

# Get all todos
@app.route('/api/todos', methods=['GET'])
def get_todos():
    todos = Todo.query.all()
    todos_list = []
    for todo in todos:
        todos_list.append({
            'todoId': todo.todoId,
            'todoName': todo.todoName,
            'todoDescription': todo.todoDescription,
            'todoBeginDate': todo.todoBeginDate.strftime('%Y-%m-%d'),
            'todoEndDate': todo.todoEndDate.strftime('%Y-%m-%d'),
            'todoStatus': todo.todoStatus,
            'id': todo.id
        })
    return jsonify({'todos': todos_list})

# Get a single todo by ID
@app.route('/api/todos/<int:todoId>', methods=['GET'])
def get_todo(todoId):
    todo = Todo.query.get(todoId)
    if todo is None:
        return jsonify({'message': 'Todo not found'}), 404
    
    return jsonify({
        'todoId': todo.todoId,
        'todoName': todo.todoName,
        'todoDescription': todo.todoDescription,
        'todoBeginDate': todo.todoBeginDate.strftime('%Y-%m-%d'),
        'todoEndDate': todo.todoEndDate.strftime('%Y-%m-%d'),
        'todoStatus': todo.todoStatus,
        'id': todo.id
    })

# Create a new todo
@app.route('/api/todos', methods=['POST'])
def create_todo():
    data = request.json
    # Extract data from request
    todoName = data.get('todoName')
    todoDescription = data.get('todoDescription')
    todoBeginDate_str = data.get('todoBeginDate')
    todoEndDate_str = data.get('todoEndDate')
    todoStatus = data.get('todoStatus')

    # Validate data
    if not todoName or not todoBeginDate_str or not todoEndDate_str:
        return jsonify({'message': 'TodoName, todoBeginDate, and todoEndDate are required'}), 400

    try:
        # Convert dates to datetime objects
        todoBeginDate = datetime.strptime(todoBeginDate_str, '%Y-%m-%d').date()
        todoEndDate = datetime.strptime(todoEndDate_str, '%Y-%m-%d').date()
    except ValueError:
        return jsonify({'message': 'Invalid date format. Please use YYYY-MM-DD'}), 400

    # Create new todo object
    todo = Todo(
        todoName=todoName,
        todoDescription=todoDescription,
        todoBeginDate=todoBeginDate,
        todoEndDate=todoEndDate,
        todoStatus=todoStatus,
        id=data.get('id')
    )

    # Add new todo to database
    db.session.add(todo)
    db.session.commit()

    return jsonify({'message': 'Todo created successfully'}), 201

# Update an existing todo
@app.route('/api/todos/<int:todoId>', methods=['PUT'])
def update_todo(todoId):
    data = request.json
    # Get the existing todo
    todo = Todo.query.get(todoId)
    if todo is None:
        return jsonify({'message': 'Todo not found'}), 404

    # Update the todo properties
    todo.todoName = data.get('todoName', todo.todoName)
    todo.todoDescription = data.get('todoDescription', todo.todoDescription)
    todo.todoBeginDate = datetime.strptime(data.get('todoBeginDate', str(todo.todoBeginDate)), '%Y-%m-%d').date()
    todo.todoEndDate = datetime.strptime(data.get('todoEndDate', str(todo.todoEndDate)), '%Y-%m-%d').date()
    todo.todoStatus = data.get('todoStatus', todo.todoStatus)
    todo.id = data.get('id', todo.id)

    # Commit changes to the database
    db.session.commit()

    return jsonify({'message': 'Todo updated successfully'}), 200

# Delete an existing todo
@app.route('/api/todos/<int:todoId>', methods=['DELETE'])
def delete_todo(todoId):
    # Get the todo to delete
    todo = Todo.query.get(todoId)
    if todo is None:
        return jsonify({'message': 'Todo not found'}), 404

    # Delete the todo from the database
    db.session.delete(todo)
    db.session.commit()

    return jsonify({'message': 'Todo deleted successfully'}), 200

@app.route('/api/userBooks', methods=['GET'])
def get_all_user_books():
    user_books = UserBook.query.all()
    if not user_books:
        return jsonify({'message': 'No user books found'}), 404
    
    books_list = []
    for user_book in user_books:
        book_data = {
            'bookId': user_book.bookId,
            'id': user_book.id,
            'bookTitle': user_book.bookTitle,
            'bookAuthor': user_book.bookAuthor,
            'bookDescription': user_book.bookDescription,
            'bookPageCount': user_book.bookPageCount,
            'bookGenre': user_book.bookGenre,
            'bookBeginDate': user_book.bookBeginDate.strftime('%Y-%m-%d'),
            'bookEndDate': user_book.bookEndDate.strftime('%Y-%m-%d'),
            'bookStatus': user_book.bookStatus
        }
        books_list.append(book_data)
    
    return jsonify(books=books_list) 
 
                   

# Get a single userBook by ID
@app.route('/api/userBooks/<int:bookId>', methods=['GET'])
def get_user_book(bookId):
    user_book = UserBook.query.get(bookId)
    if user_book is None:
        return jsonify({'message': 'User Book not found'}), 404
    
    return jsonify({
        'bookId': user_book.bookId,
        'id': user_book.id,
        'bookTitle': user_book.bookTitle,
        'bookAuthor': user_book.bookAuthor,
        'bookDescription': user_book.bookDescription,
        'bookPageCount': user_book.bookPageCount,
        'bookGenre': user_book.bookGenre,
        'bookBeginDate': user_book.bookBeginDate.strftime('%Y-%m-%d'),
        'bookEndDate': user_book.bookEndDate.strftime('%Y-%m-%d'),
        'bookStatus': user_book.bookStatus
    })

# Route to create a new userBook
@app.route('/api/userBooks', methods=['POST'])
def create_user_book():
    data = request.json
    # Extract data from request
    # id = data.get('id')
    bookTitle = data.get('bookTitle')
    bookAuthor = data.get('bookAuthor')
    bookDescription = data.get('bookDescription')
    bookPageCount = data.get('bookPageCount')
    bookGenre = data.get('bookGenre')
    bookBeginDate_str = data.get('bookBeginDate')
    bookEndDate_str = data.get('bookEndDate')
    bookStatus = data.get('bookStatus')

    # Validate data
    if not all([id, bookTitle, bookAuthor, bookDescription, bookPageCount, bookGenre, bookBeginDate_str, bookEndDate_str, bookStatus]):
        return jsonify({'message': 'All fields are required'}), 400

    try:
        # Convert dates to datetime objects
        bookBeginDate = datetime.strptime(bookBeginDate_str, '%Y-%m-%d').date()
        bookEndDate = datetime.strptime(bookEndDate_str, '%Y-%m-%d').date()
    except ValueError:
        return jsonify({'message': 'Invalid date format. Please use YYYY-MM-DD'}), 400

    # Create new userBook object
    user_book = UserBook(
        id=data.get('id'),
        bookTitle=bookTitle,
        bookAuthor=bookAuthor,
        bookDescription=bookDescription,
        bookPageCount=bookPageCount,
        bookGenre=bookGenre,
        bookBeginDate=bookBeginDate,
        bookEndDate=bookEndDate,
        bookStatus=bookStatus
    )

    # Add new userBook to database
    db.session.add(user_book)
    db.session.commit()

    return jsonify({'message': 'User book created successfully'}), 201

# Update an existing userBook
@app.route('/api/userBooks/<int:bookId>', methods=['PUT'])
def update_user_book(bookId):
    data = request.json
    # Get the existing userBook
    user_book = UserBook.query.get(bookId)
    if user_book is None:
        return jsonify({'message': 'User Book not found'}), 404

    # Update the userBook properties
    user_book.id = data.get('id', user_book.id)
    user_book.bookTitle = data.get('bookTitle', user_book.bookTitle)
    user_book.bookAuthor = data.get('bookAuthor', user_book.bookAuthor)
    user_book.bookDescription = data.get('bookDescription', user_book.bookDescription)
    user_book.bookPageCount = data.get('bookPageCount', user_book.bookPageCount)
    user_book.bookGenre = data.get('bookGenre', user_book.bookGenre)
    user_book.bookBeginDate = datetime.strptime(data.get('bookBeginDate', str(user_book.bookBeginDate)), '%Y-%m-%d').date()
    user_book.bookEndDate = datetime.strptime(data.get('bookEndDate', str(user_book.bookEndDate)), '%Y-%m-%d').date()
    user_book.bookStatus = data.get('bookStatus', user_book.bookStatus)

    # Commit changes to the database
    db.session.commit()

    return jsonify({'message': 'User Book updated successfully'}), 200

# Delete an existing userBook
@app.route('/api/userBooks/<int:bookId>', methods=['DELETE'])
def delete_user_book(bookId):
    # Get the userBook to delete
    user_book = UserBook.query.get(bookId)
    if user_book is None:
        return jsonify({'message': 'User Book not found'}), 404

    # Delete the userBook from the database
    db.session.delete(user_book)
    db.session.commit()

    return jsonify({'message': 'User Book deleted successfully'}), 200

# Get all events
@app.route('/api/events', methods=['GET'])
def get_events():
    events = Event.query.all()
    events_list = []
    for event in events:
        events_list.append({
            'eventId': event.eventId,
            'id': event.id,
            'eventTitle': event.eventTitle,
            'eventDomain': event.eventDomain,
            'eventDescription': event.eventDescription,
            'eventBeginDate': event.eventBeginDate.strftime('%Y-%m-%d %H:%M:%S'), 
            'eventEndDate': event.eventEndDate.strftime('%Y-%m-%d %H:%M:%S'),
            'eventLocation': event.eventLocation,
            'eventSpeaker': event.eventSpeaker,
            'eventMode': event.eventMode,
            'eventStatus': event.eventStatus
        })
    return jsonify({'events': events_list})
# Get a single event by ID
@app.route('/api/events/<int:eventId>', methods=['GET'])
def get_event(eventId):
    event = Event.query.get(eventId)
    if event is None:
        return jsonify({'message': 'Event not found'}), 404
    
    return jsonify({
        'eventId': event.eventId,
        'id': event.id,
        'eventTitle': event.eventTitle,
        'eventDomain': event.eventDomain,
        'eventDescription': event.eventDescription,
        'eventBeginDate': event.eventBeginDate.strftime('%Y-%m-%d %H:%M:%S'),  # Format datetime
        'eventEndDate': event.eventEndDate.strftime('%Y-%m-%d %H:%M:%S'),
        'eventLocation': event.eventLocation,
        'eventSpeaker': event.eventSpeaker,
        'eventMode': event.eventMode,
        'eventStatus': event.eventStatus
    })

# Create a new event
@app.route('/api/events', methods=['POST'])
def create_event():
    data = request.json
    # Extract data from request
    # id = data.get('id')
    eventTitle = data.get('eventTitle')
    eventDomain = data.get('eventDomain')
    eventDescription = data.get('eventDescription')
    eventBeginDate_str = data.get('eventBeginDate')
    eventEndDate_str = data.get('eventEndDate')
    eventLocation = data.get('eventLocation')
    eventSpeaker = data.get('eventSpeaker')
    eventMode = data.get('eventMode')
    eventStatus = data.get('eventStatus')

    # Validate data
    if not all([ eventTitle, eventDomain, eventDescription, eventBeginDate_str, eventEndDate_str, eventLocation, eventSpeaker, eventMode, eventStatus]):
        return jsonify({'message': 'All fields are required'}), 400

    try:
        # Convert dates to datetime objects
        eventBeginDate = datetime.strptime(eventBeginDate_str, '%Y-%m-%d %H:%M:%S')
        eventEndDate = datetime.strptime(eventEndDate_str, '%Y-%m-%d %H:%M:%S')
    except ValueError:
        return jsonify({'message': 'Invalid date format. Please use YYYY-MM-DD'}), 400

    # Create new event object
    event = Event(
        id = 1,
        eventTitle=eventTitle,
        eventDomain=eventDomain,
        eventDescription=eventDescription,
        eventBeginDate=eventBeginDate,
        eventEndDate=eventEndDate,
        eventLocation=eventLocation,
        eventSpeaker=eventSpeaker,
        eventMode=eventMode,
        eventStatus=eventStatus
    )

    # Add new event to database
    db.session.add(event)
    db.session.commit()

    return jsonify({'message': 'Event created successfully'}), 201

# Update an existing event
@app.route('/api/events/<int:eventId>', methods=['PUT'])
def update_event(eventId):
    data = request.json
    # Get the existing event
    event = Event.query.get(eventId)
    if event is None:
        return jsonify({'message': 'Event not found'}), 404

    # Update the event properties
    event.id = data.get('id', event.id)
    event.eventTitle = data.get('eventTitle', event.eventTitle)
    event.eventDomain = data.get('eventDomain', event.eventDomain)
    event.eventDescription = data.get('eventDescription', event.eventDescription)
    event.eventBeginDate = datetime.strptime(data.get('eventBeginDate', str(event.eventBeginDate)), '%Y-%m-%d %H:%M:%S')
    event.eventEndDate = datetime.strptime(data.get('eventEndDate', str(event.eventEndDate)), '%Y-%m-%d %H:%M:%S')
    event.eventLocation = data.get('eventLocation', event.eventLocation)
    event.eventSpeaker = data.get('eventSpeaker', event.eventSpeaker)
    event.eventMode = data.get('eventMode', event.eventMode)
    event.eventStatus = data.get('eventStatus', event.eventStatus)

    # Commit changes to the database
    db.session.commit()

    return jsonify({'message': 'Event updated successfully'}), 200

# Delete an existing event
@app.route('/api/events/<int:eventId>', methods=['DELETE'])
def delete_event(eventId):
    # Get the event to delete
    event = Event.query.get(eventId)
    if event is None:
        return jsonify({'message': 'Event not found'}), 404

    # Delete the event from the database
    db.session.delete(event)
    db.session.commit()

    return jsonify({'message': 'Event deleted successfully'}), 200

# API endpoints for Meeting
@app.route('/api/meetings', methods=['GET'])
def get_meetings():
    meetings = Meeting.query.all()
    meetings_list = []
    for meeting in meetings:
        meetings_list.append({
            'meetingId': meeting.meetingId,
            'id': meeting.id,
            'meetingTitle': meeting.meetingTitle,
            'meetingBeginDate': meeting.meetingBeginDate.strftime('%Y-%m-%d %H:%M:%S'),
            'meetingEndDate': meeting.meetingEndDate.strftime('%Y-%m-%d %H:%M:%S'),
            'meetingDescription': meeting.meetingDescription,
            'meetingStatus': meeting.meetingStatus
        })
    return jsonify({'meetings': meetings_list})

@app.route('/api/meetings/<int:meetingId>', methods=['GET'])
def get_meeting(meetingId):
    meeting = Meeting.query.get(meetingId)
    if meeting is None:
        return jsonify({'message': 'Meeting not found'}), 404
    
    return jsonify({
        'meetingId': meeting.meetingId,
        'id': meeting.id,
        'meetingTitle': meeting.meetingTitle,
        'meetingBeginDate': meeting.meetingBeginDate.strftime('%Y-%m-%d %H:%M:%S'),
        'meetingEndDate': meeting.meetingEndDate.strftime('%Y-%m-%d %H:%M:%S'),
        'meetingDescription': meeting.meetingDescription,
        'meetingStatus': meeting.meetingStatus
    })

@app.route('/api/meetings', methods=['POST'])
def create_meeting():
    data = request.json
    # Extract data from request
    meetingTitle = data.get('meetingTitle')
    meetingBeginDate_str = data.get('meetingBeginDate')
    meetingEndDate_str = data.get('meetingEndDate')
    meetingDescription = data.get('meetingDescription')
    meetingStatus = data.get('meetingStatus')

    # Validate data
    if not all([meetingTitle, meetingBeginDate_str, meetingEndDate_str, meetingDescription, meetingStatus]):
        return jsonify({'message': 'All fields are required'}), 400

    try:
        # Convert dates to datetime objects
        meetingBeginDate = datetime.strptime(meetingBeginDate_str, '%Y-%m-%d %H:%M:%S')
        meetingEndDate = datetime.strptime(meetingEndDate_str, '%Y-%m-%d %H:%M:%S')
    except ValueError:
        return jsonify({'message': 'Invalid date format. Please use YYYY-MM-DD HH:MM:SS'}), 400

    # Create new meeting object
    meeting = Meeting(
        meetingTitle=meetingTitle,
        meetingBeginDate=meetingBeginDate,
        meetingEndDate=meetingEndDate,
        meetingDescription=meetingDescription,
        meetingStatus=meetingStatus,
        id=data.get('id')
    )

    # Add new meeting to database
    db.session.add(meeting)
    db.session.commit()

    return jsonify({'message': 'Meeting created successfully'}), 201

@app.route('/api/meetings/<int:meetingId>', methods=['PUT'])
def update_meeting(meetingId):
    data = request.json
    # Get the existing meeting
    meeting = Meeting.query.get(meetingId)
    if meeting is None:
        return jsonify({'message': 'Meeting not found'}), 404

    # Update the meeting properties
    meeting.meetingTitle = data.get('meetingTitle', meeting.meetingTitle)
    meeting.meetingBeginDate = datetime.strptime(data.get('meetingBeginDate', str(meeting.meetingBeginDate)), '%Y-%m-%d %H:%M:%S')
    meeting.meetingEndDate = datetime.strptime(data.get('meetingEndDate', str(meeting.meetingEndDate)), '%Y-%m-%d %H:%M:%S')
    meeting.meetingDescription = data.get('meetingDescription', meeting.meetingDescription)
    meeting.meetingStatus = data.get('meetingStatus', meeting.meetingStatus)
    meeting.id = data.get('id', meeting.id)

    # Commit changes to the database
    db.session.commit()

    return jsonify({'message': 'Meeting updated successfully'}), 200

@app.route('/api/meetings/<int:meetingId>', methods=['DELETE'])
def delete_meeting(meetingId):
    # Get the meeting to delete
    meeting = Meeting.query.get(meetingId)
    if meeting is None:
        return jsonify({'message': 'Meeting not found'}), 404

    # Delete the meeting from the database
    db.session.delete(meeting)
    db.session.commit()

    return jsonify({'message': 'Meeting deleted successfully'}), 200

if __name__ == '__main__':
    app.run(debug=True)
