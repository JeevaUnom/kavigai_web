-- goal page

CREATE TABLE goals (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    begin_date DATE NOT NULL,
    end_date DATE NOT NULL,
    url VARCHAR(255),
    status VARCHAR(50) NOT NULL DEFAULT 'New'
);

--user table
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL
);

CREATE TABLE books (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(255) NOT NULL,
    image_url VARCHAR(255),
    genre VARCHAR(100),
    number_of_pages INTEGER,
    ratings DECIMAL(3, 2),
    number_of_peoples_rated INTEGER,
    description TEXT
);

CREATE TABLE todo (
    todoId SERIAL PRIMARY KEY,
    todoName VARCHAR(255) NOT NULL, 
    todoDescription TEXT,
    todoBeginDate DATE,
    todoEndDate DATE,
    todoStatus VARCHAR(50),
    id INT,
    FOREIGN KEY (id) REFERENCES goals(id)
);

CREATE TABLE userBook (
    bookId SERIAL PRIMARY KEY,
    id INTEGER NOT NULL,
    bookTitle VARCHAR(255) NOT NULL,
    bookAuthor VARCHAR(255) NOT NULL,
    bookDescription TEXT NOT NULL,
    bookPageCount INTEGER NOT NULL,
    bookGenre VARCHAR(100) NOT NULL,
    bookBeginDate DATE NOT NULL,
    bookEndDate DATE NOT NULL,
    bookStatus VARCHAR(50) NOT NULL,
    FOREIGN KEY (id) REFERENCES goals(id)
);

CREATE TABLE event (
    eventId SERIAL PRIMARY KEY,
    eventTitle VARCHAR(255) NOT NULL,
    eventDomain VARCHAR(255) NOT NULL,
    eventBeginDate TIMESTAMP NOT NULL,
    eventEndDate TIMESTAMP NOT NULL,
    eventLocation VARCHAR(255) NOT NULL,
    eventSpeaker VARCHAR(255) NOT NULL,
    eventMode VARCHAR(255) NOT NULL,
    eventDescription TEXT NOT NULL,
    id INTEGER NOT NULL REFERENCES goals(id)
);
CREATE TABLE meeting (
    meetingId SERIAL PRIMARY KEY,
    id INTEGER NOT NULL,
    meetingTitle VARCHAR(255) NOT NULL,
    meetingBeginDate TIMESTAMP NOT NULL,
    meetingEndDate TIMESTAMP NOT NULL,
    meetingDescription TEXT NOT NULL,
    meetingStatus VARCHAR(50) NOT NULL,
    FOREIGN KEY (id) REFERENCES goals(id)
);
