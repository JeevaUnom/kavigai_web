-- goal page

CREATE TABLE your_table_name (
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
    FOREIGN KEY (id) REFERENCES goal(id)
);

