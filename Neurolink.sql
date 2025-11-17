-- Project: Neurolink — Human Memory & Emotion Mapping
-- Description: Full SQL schema + sample data
DROP DATABASE IF EXISTS Neurolink;
CREATE DATABASE Neurolink;
USE Neurolink;

-- 1) TABLES (9) 
CREATE TABLE Person (
  person_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  age INT CHECK(age > 0),
  gender ENUM('Male','Female','Other') DEFAULT 'Other',
  occupation VARCHAR(80)
) ENGINE=InnoDB;

CREATE TABLE Event (
  event_id INT AUTO_INCREMENT PRIMARY KEY,
  event_name VARCHAR(120) NOT NULL,
  event_type VARCHAR(60),
  event_date DATE
) ENGINE=InnoDB;
CREATE TABLE Emotion (
  emotion_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  valence ENUM('positive','negative','neutral') DEFAULT 'neutral',
  arousal_level INT CHECK(arousal_level BETWEEN 1 AND 10)
) ENGINE=InnoDB;

CREATE TABLE Tag (
  tag_id INT AUTO_INCREMENT PRIMARY KEY,
  tag_name VARCHAR(50) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE Therapist (
  therapist_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  specialization VARCHAR(100)
) ENGINE=InnoDB;

CREATE TABLE MemoryLog (
  memory_id INT AUTO_INCREMENT PRIMARY KEY,
  person_id INT NOT NULL,
  event_id INT,
  title VARCHAR(150),
  description TEXT,
  date_occurred DATE,
  vividness TINYINT CHECK(vividness BETWEEN 1 AND 10) DEFAULT 5,
  emotional_intensity TINYINT CHECK(emotional_intensity BETWEEN 1 AND 10) DEFAULT 5,
  emotion_id INT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (person_id) REFERENCES Person(person_id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (event_id) REFERENCES Event(event_id) ON DELETE SET NULL,
  FOREIGN KEY (emotion_id) REFERENCES Emotion(emotion_id) ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE MemoryTag (
  memory_id INT NOT NULL,
  tag_id INT NOT NULL,
  PRIMARY KEY(memory_id, tag_id),
  FOREIGN KEY (memory_id) REFERENCES MemoryLog(memory_id) ON DELETE CASCADE,
  FOREIGN KEY (tag_id) REFERENCES Tag(tag_id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE TherapySession (
  session_id INT AUTO_INCREMENT PRIMARY KEY,
  person_id INT NOT NULL,
  therapist_id INT NOT NULL,
  session_date DATE,
  focus_notes TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (person_id) REFERENCES Person(person_id) ON DELETE CASCADE,
  FOREIGN KEY (therapist_id) REFERENCES Therapist(therapist_id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE SensorData (
  sensor_id INT AUTO_INCREMENT PRIMARY KEY,
  person_id INT NOT NULL,
  recorded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  heart_rate SMALLINT,
  face_emotion_score DECIMAL(4,2),
  notes VARCHAR(200),
  FOREIGN KEY (person_id) REFERENCES Person(person_id) ON DELETE CASCADE
) ENGINE=InnoDB;


-- 2) SAMPLE DATA


-- PERSON
INSERT INTO Person (name, age, gender, occupation) VALUES
('Afsara', 22, 'Female', 'Student'),
('Rahim', 24, 'Male', 'Researcher'),
('Mahinur', 28, 'Female', 'Teacher'),
('Ahnaf', 30, 'Male', 'Engineer'),
('Tithi', 26, 'Female', 'Designer'),
('Tanvir', 35, 'Male', 'Entrepreneur');

-- EVENT
INSERT INTO Event (event_name, event_type, event_date) VALUES
('Summer Picnic', 'Personal', '2022-06-15'),
('Final Exam Result', 'Academic', '2023-03-20'),
('Music Concert', 'Social', '2019-08-23'),
('Office Party', 'Work', '2022-12-10'),
('Family Reunion', 'Personal', '2021-11-05'),
('Job Interview', 'Career', '2023-02-15');

-- EMOTION
INSERT INTO Emotion (name, valence, arousal_level) VALUES
('Joy', 'positive', 8),
('Sadness', 'negative', 3),
('Nostalgia', 'neutral', 6),
('Anxiety', 'negative', 7),
('Excitement', 'positive', 9),
('Frustration', 'negative', 5);

-- TAGS
INSERT INTO Tag (tag_name) VALUES
('Childhood'),('Travel'),('Music'),('Career'),('Family'),('Stress');

-- THERAPIST
INSERT INTO Therapist (name, specialization) VALUES
('Dr. Sultana','Clinical Psychology'),
('Dr. Karim','Counseling'),
('Dr. Rahman','Behavioral Therapy');

-- MEMORYLOG (2 per person sample)
INSERT INTO MemoryLog (person_id, event_id, title, description, date_occurred, vividness, emotional_intensity, emotion_id) VALUES
(1,1,'Family Picnic','Fun picnic at park','2022-06-15',9,8,1),
(1,2,'Exam Result','Felt sad after low score','2023-03-20',6,7,2),
(2,3,'First Concert','Exciting music experience','2019-08-23',8,9,5),
(2,6,'Job Interview','Nervous before interview','2023-02-15',7,7,4),
(3,2,'Exam Waiting','Anxious before results','2023-03-20',5,6,4),
(3,5,'Family Gathering','Reunion with cousins','2021-11-05',7,7,3),
(4,4,'Office Party','Colleagues celebration','2022-12-10',7,7,5),
(4,1,'Summer Picnic','Relaxing picnic day','2022-06-15',8,8,1),
(5,3,'Concert Night','Music night with friends','2019-08-23',8,8,5),
(5,5,'Family Reunion','Met family','2021-11-05',7,6,3),
(6,6,'Interview Day','Career interview','2023-02-15',8,9,4),
(6,2,'Exam Stress','High tension before exams','2023-03-20',6,7,4);

-- MEMORY TAGS
INSERT INTO MemoryTag (memory_id, tag_id) VALUES
(1,1),(1,2),(2,6),(3,3),(4,4),(5,5),(6,5),(7,4),(8,2),(9,3),(10,5),(11,4),(12,6);

-- THERAPY SESSION
INSERT INTO TherapySession (person_id, therapist_id, session_date, focus_notes) VALUES
(1,1,'2023-04-01','Discussed coping with exam stress'),
(2,2,'2020-09-10','Discussed social anxiety at concerts');

-- SENSOR DATA
INSERT INTO SensorData (person_id, heart_rate, face_emotion_score, notes) VALUES
(1,72,0.85,'during picnic'),
(1,88,0.30,'after exam'),
(2,95,0.92,'at concert'),
(2,80,0.65,'office workshop'),
(3,80,0.40,'pre-exam anxiety'),
(3,78,0.70,'family gathering'),
(4,82,0.88,'office party'),
(4,76,0.60,'concert memories'),
(5,75,0.75,'family reunion'),
(5,79,0.80,'concert night'),
(6,85,0.90,'interview day'),
(6,77,0.70,'office party');


-- 3) TRIGGER

DELIMITER $$
CREATE TRIGGER trg_memory_vividness_check
AFTER UPDATE ON MemoryLog
FOR EACH ROW
BEGIN
  IF NEW.vividness < 3 THEN
    INSERT INTO TherapySession (person_id, therapist_id, session_date, focus_notes)
    VALUES (NEW.person_id, 1, CURDATE(),
            CONCAT('Vividness dropped to ', NEW.vividness,
                   '. Recommend follow-up for memory_id=', NEW.memory_id));
  END IF;
END$$
DELIMITER ;


-- 4) PROCEDURE

DELIMITER $$
CREATE PROCEDURE get_top_memories(IN pid INT)
BEGIN
  SELECT memory_id, title, date_occurred, emotional_intensity, vividness
  FROM MemoryLog
  WHERE person_id = pid
  ORDER BY emotional_intensity DESC, vividness DESC
  LIMIT 5;
END$$
DELIMITER ;


-- 5) FUNCTION

DELIMITER $$
CREATE FUNCTION person_emotion_index(pid INT) RETURNS DECIMAL(6,3)
DETERMINISTIC
BEGIN
  DECLARE avg_intensity DECIMAL(5,2);
  DECLARE recent_sensor DECIMAL(4,2);

  SELECT IFNULL(AVG(emotional_intensity),0)
  INTO avg_intensity
  FROM MemoryLog
  WHERE person_id = pid;

  SELECT IFNULL(face_emotion_score,0)
  INTO recent_sensor
  FROM SensorData
  WHERE person_id = pid
  ORDER BY recorded_at DESC LIMIT 1;

  RETURN ROUND((0.7 * (avg_intensity / 10.0) + 0.3 * recent_sensor), 3);
END$$
DELIMITER ;


-- 6) VIEW

CREATE OR REPLACE VIEW MemoryEmotionView AS
SELECT ml.memory_id,
       p.person_id, p.name AS person_name,
       e.event_name,
       ml.title, ml.date_occurred,
       emo.name AS emotion_name,
       ml.emotional_intensity, ml.vividness
FROM MemoryLog ml
LEFT JOIN Person p ON ml.person_id = p.person_id
LEFT JOIN Event e ON ml.event_id = e.event_id
LEFT JOIN Emotion emo ON ml.emotion_id = emo.emotion_id;

-- EASY
SELECT * FROM Person;
SELECT * FROM MemoryLog WHERE person_id = 1 ORDER BY date_occurred DESC;
INSERT INTO MemoryLog (person_id, event_id, title, description, date_occurred, vividness, emotional_intensity, emotion_id)
VALUES (2, 1, 'Quiet Beach Walk', 'Reflective walk by the sea', '2024-01-10', 7, 6, 3);
UPDATE MemoryLog SET vividness = 4 WHERE memory_id = 2;
DELETE FROM SensorData
WHERE sensor_id = (SELECT sensor_id FROM (SELECT sensor_id FROM SensorData WHERE notes LIKE '%pre-exam%' LIMIT 1) AS t);

-- MEDIUM
SELECT p.name, COUNT(ml.memory_id) AS total_memories
FROM Person p
LEFT JOIN MemoryLog ml ON p.person_id = ml.person_id
GROUP BY p.person_id, p.name;

SELECT e.event_name, ROUND(AVG(ml.emotional_intensity),2) AS avg_emotion
FROM Event e
JOIN MemoryLog ml ON e.event_id = ml.event_id
GROUP BY e.event_id, e.event_name
HAVING AVG(ml.emotional_intensity) >= 6;

SELECT ml.memory_id, p.name, ml.title, emo.name AS emotion, ml.emotional_intensity, ml.vividness
FROM MemoryLog ml
JOIN Person p ON ml.person_id = p.person_id
JOIN Emotion emo ON ml.emotion_id = emo.emotion_id
ORDER BY ml.emotional_intensity DESC;

SELECT p.person_id, p.name, COUNT(*) AS high_count
FROM MemoryLog ml
JOIN Person p ON ml.person_id = p.person_id
WHERE ml.emotional_intensity >= 8
GROUP BY p.person_id, p.name
HAVING COUNT(*) > 1;

SELECT s.sensor_id, p.name, s.heart_rate, s.recorded_at
FROM SensorData s
JOIN Person p ON s.person_id = p.person_id
WHERE s.heart_rate > 90
ORDER BY s.recorded_at DESC;

-- ADVANCED
SELECT ml.memory_id, ml.title, ml.emotional_intensity
FROM MemoryLog ml
WHERE ml.emotional_intensity > (
  SELECT AVG(m2.emotional_intensity)
  FROM MemoryLog m2
  WHERE m2.person_id = ml.person_id
)
ORDER BY ml.emotional_intensity DESC;

CALL get_top_memories(1);

SELECT person_id, name, person_emotion_index(person_id) AS emotion_index
FROM Person;

SELECT * FROM MemoryEmotionView ORDER BY emotional_intensity DESC LIMIT 10;

SELECT p.person_id, p.name,
       ROUND(AVG(ml.emotional_intensity),2) AS avg_emotion,
       (SELECT sd.face_emotion_score
        FROM SensorData sd
        WHERE sd.person_id = p.person_id
        ORDER BY sd.recorded_at DESC LIMIT 1) AS recent_face_score
FROM Person p
LEFT JOIN MemoryLog ml ON p.person_id = ml.person_id
GROUP BY p.person_id
HAVING avg_emotion > 7 AND recent_face_score < 0.5;

