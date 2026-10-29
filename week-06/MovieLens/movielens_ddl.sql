CREATE TABLE dm_date (
    date_id INT PRIMARY KEY,
    day VARCHAR(45),
    day_of_week VARCHAR(45),
    week INT,
    month INT,
    month_name VARCHAR(45),
    year INT,
    quarter INT
);


CREATE TABLE dm_time (
    time_id INT PRIMARY KEY,
    hour INT,
    minute INT,
    second INT,
    part_of_day CHAR(2)
);


CREATE TABLE dm_movie (
    movie_id INT PRIMARY KEY,
    title VARCHAR(255),
    release_year CHAR(4)
);


CREATE TABLE dm_genre (
    genre_id INT PRIMARY KEY,
    genre_name VARCHAR(255)
);


CREATE TABLE dm_user (
    user_id INT PRIMARY KEY,
    gender CHAR(1),
    zip_code VARCHAR(255),
    age_group VARCHAR(45),
    occupation_name VARCHAR(255)
);


CREATE TABLE bridge (
    bridge_id INT PRIMARY KEY,
    movie_id INT,
    genre_id INT,
    CONSTRAINT fk_bridge_movie_id FOREIGN KEY (movie_id) REFERENCES dm_movie(movie_id),
    CONSTRAINT fk_bridge_genre_id FOREIGN KEY (genre_id) REFERENCES dm_genre(genre_id)
);


CREATE TABLE fact_ratings (
    rating_id INT PRIMARY KEY,
    rating INT,
    rated_at DATETIME,
    dm_date_date_id INT,
    dm_movie_movie_id INT,
    dm_time_time_id INT,
    dm_user_user_id INT,
    CONSTRAINT fk_ratings_date_id FOREIGN KEY (dm_date_date_id) REFERENCES dm_date(date_id),
    CONSTRAINT fk_ratings_movie_id FOREIGN KEY (dm_movie_movie_id) REFERENCES dm_movie(movie_id),
    CONSTRAINT fk_ratings_time_id FOREIGN KEY (dm_time_time_id) REFERENCES dm_time(time_id),
    CONSTRAINT fk_ratings_user_id FOREIGN KEY (dm_user_user_id) REFERENCES dm_user(user_id)
);


CREATE TABLE fact_tags (
    tag_id INT PRIMARY KEY,
    tag_name VARCHAR(4000),
    created_at DATETIME,
    dm_date_date_id INT,
    dm_movie_movie_id INT,
    dm_time_time_id INT,
    dm_user_user_id INT,
    CONSTRAINT fk_tags_date_id FOREIGN KEY (dm_date_date_id) REFERENCES dm_date(date_id),
    CONSTRAINT fk_tags_movie_id FOREIGN KEY (dm_movie_movie_id) REFERENCES dm_movie(movie_id),
    CONSTRAINT fk_tags_time_id FOREIGN KEY (dm_time_time_id) REFERENCES dm_time(time_id),
    CONSTRAINT fk_tags_user_id FOREIGN KEY (dm_user_user_id) REFERENCES dm_user(user_id)
);