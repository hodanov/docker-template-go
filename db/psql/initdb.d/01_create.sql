CREATE TABLE snippets (
    id SERIAL PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    content TEXT NOT NULL,
    created TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_snippets_created ON snippets(created);

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    age INT NOT NULL,
    created TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_users_created ON users(created);
