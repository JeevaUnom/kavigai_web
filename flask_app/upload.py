import psycopg2
import csv

# Database connection parameters
dbname = 'kavigai'
user = 'postgres'
password = 'jeeva'
host = 'localhost'
port = '5432'

# CSV file path
csv_file = 'C:\\Users\\jeeva\\project\\flutter\\kavigai\\data\\Books (13).csv'

# Connect to the PostgreSQL database
conn = psycopg2.connect(
    dbname=dbname,
    user=user,
    password=password,
    host=host,
    port=port
)

# Create a cursor object
cur = conn.cursor()

# Function to insert data from CSV file into the database
def insert_data_from_csv(file_path):
    with open(file_path, 'r', newline='', encoding='utf-8') as f:
        reader = csv.reader(f)
        next(reader)  # Skip header row
        for row in reader:
            # Prepare the INSERT statement
            query = """
                INSERT INTO books (title, author, image_url, genre, number_of_pages, publication_date, ratings, number_of_people_rates, description)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
            """
            # Execute the INSERT statement with row data
            cur.execute(query, row)

# Insert data from CSV file
insert_data_from_csv(csv_file)

# Commit the transaction
conn.commit()

# Close cursor and connection
cur.close()
conn.close()

print("Data inserted successfully.")
