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
