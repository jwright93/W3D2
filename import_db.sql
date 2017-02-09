DROP TABLE IF EXISTS users;

CREATE TABLE users (
  id  INTEGER PRIMARY KEY,
  fname TEXT NOT NULL,
  lname TEXT NOT NULL
);


DROP TABLE IF EXISTS questions;

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  author_id INTEGER NOT NULL,

  FOREIGN KEY (author_id) REFERENCES users(id)
);


DROP TABLE IF EXISTS question_follows;

CREATE TABLE question_follows (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES  questions(id)
);


DROP TABLE IF EXISTS replies;

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  parent_id INTEGER,
  user_id INTEGER NOT NULL,
  body TEXT NOT NULL,

  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (parent_id) REFERENCES replies(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS question_likes;

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id)
  FOREIGN KEY (question_id) REFERENCES questions(id)
);


INSERT INTO
  users (fname, lname)
VALUES
  ('Jane', 'Doe'),
  ('John', 'Doe'),
  ('Jack', 'Doe'),
  ('Jenny', 'Doe');

INSERT INTO
  questions (title, body, author_id)
VALUES
  ('What is this?', 'This is not working, yadda yadda yadda',
    (SELECT id FROM users WHERE fname = 'John')),
  ('When?', 'now',
    (SELECT id FROM users WHERE fname = 'Jane')),
  ('Where?', 'Really... why?',
    (SELECT id FROM users WHERE fname = 'Jane')),
  ('Who?', 'Really... why?',
    (SELECT id FROM users WHERE fname = 'Jane')),
  ('What?', 'Really... why?',
    (SELECT id FROM users WHERE fname = 'Jane'));

INSERT INTO
  replies (question_id, parent_id, user_id, body)
VALUES
  (1, NULL, 2, 'something'),
  (2, 1, 1, 'something else'),
  (2, 1, 1, 'somethingadf  else'),
  (2, 1, 1, 'something a fa fdaelse'),
  (2, 1, 1, 'something fadsf else'),
  (2, 1, 1, 'something adf weelse');

  INSERT INTO
    question_follows (user_id, question_id)
  VALUES
    (1,1),
    (2,1),
    (1,2),
    (2,2),
    (4,2),
    (3,2),
    (4,1),
    (3,3),
    (2,3);


  INSERT INTO
    question_likes (user_id, question_id)
  VALUES
    (1,1),
    (2,1),
    (1,2),
    (2,2),
    (4,2),
    (3,2),
    (4,1),
    (3,3),
    (2,3);
