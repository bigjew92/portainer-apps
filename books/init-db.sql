-- Bootstrap init script for bookkeep
-- This creates the base schema that Alembic migrations expect to start from.
-- Docker Postgres only runs this on a FRESH (empty) database.

CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    email VARCHAR UNIQUE NOT NULL,
    username VARCHAR UNIQUE NOT NULL,
    hashed_password VARCHAR,
    full_name VARCHAR,
    oidc_subject VARCHAR UNIQUE,
    is_active BOOLEAN DEFAULT TRUE,
    is_admin BOOLEAN DEFAULT FALSE,
    can_request_ebook BOOLEAN DEFAULT TRUE,
    can_request_audiobook BOOLEAN DEFAULT TRUE,
    can_download BOOLEAN DEFAULT TRUE,
    auto_approve_ebooks BOOLEAN DEFAULT TRUE,
    auto_approve_audiobooks BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS ix_users_id ON users (id);
CREATE INDEX IF NOT EXISTS ix_users_email ON users (email);
CREATE INDEX IF NOT EXISTS ix_users_username ON users (username);
CREATE INDEX IF NOT EXISTS ix_users_oidc_subject ON users (oidc_subject);

CREATE TABLE IF NOT EXISTS books (
    id SERIAL PRIMARY KEY,
    title VARCHAR NOT NULL,
    author VARCHAR NOT NULL,
    author_id INTEGER,
    isbn VARCHAR UNIQUE,
    description TEXT,
    cover_url VARCHAR,
    genre VARCHAR,
    published_date VARCHAR,
    rating FLOAT,
    page_count INTEGER,
    hardcover_id INTEGER UNIQUE,
    hardcover_slug VARCHAR,
    booklore_id INTEGER UNIQUE,
    booklore_added_on TIMESTAMPTZ,
    audiobookshelf_id VARCHAR UNIQUE,
    default_edition_id INTEGER,
    default_physical_edition_id INTEGER,
    default_ebook_edition_id INTEGER,
    default_audio_edition_id INTEGER,
    series VARCHAR,
    series_id INTEGER,
    series_position FLOAT,
    genres VARCHAR,
    ratings_count INTEGER,
    users_count INTEGER,
    activities_count INTEGER,
    release_year INTEGER,
    is_seed_data BOOLEAN DEFAULT FALSE,
    ebook_available BOOLEAN DEFAULT FALSE,
    audiobook_available BOOLEAN DEFAULT FALSE,
    last_refreshed TIMESTAMPTZ,
    downloaded_release_hashes TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS ix_books_id ON books (id);
CREATE INDEX IF NOT EXISTS ix_books_title ON books (title);
CREATE INDEX IF NOT EXISTS ix_books_isbn ON books (isbn);
CREATE INDEX IF NOT EXISTS ix_books_hardcover_id ON books (hardcover_id);
CREATE INDEX IF NOT EXISTS ix_books_hardcover_slug ON books (hardcover_slug);
CREATE INDEX IF NOT EXISTS ix_books_booklore_id ON books (booklore_id);
CREATE INDEX IF NOT EXISTS ix_books_audiobookshelf_id ON books (audiobookshelf_id);
CREATE INDEX IF NOT EXISTS ix_books_series_id ON books (series_id);
CREATE INDEX IF NOT EXISTS ix_books_author_id ON books (author_id);

CREATE TABLE IF NOT EXISTS series (
    id SERIAL PRIMARY KEY,
    hardcover_id INTEGER UNIQUE NOT NULL,
    name VARCHAR NOT NULL,
    books_count INTEGER,
    is_seed_data BOOLEAN DEFAULT FALSE
);

CREATE INDEX IF NOT EXISTS ix_series_id ON series (id);
CREATE INDEX IF NOT EXISTS ix_series_hardcover_id ON series (hardcover_id);
CREATE INDEX IF NOT EXISTS ix_series_name ON series (name);
