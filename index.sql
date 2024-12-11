-- zakaria elouannasse 
-- email:elouannassez@gmai.com 

--Création de la table subscription:

CREATE TABLE subscription (
    SubscriptionID INT PRIMARY KEY,
    SubscriptionType VARCHAR(50) NOT NULL CHECK (SubscriptionType IN ('Basic',  'Premium')),
    MonthlyFee DECIMAL(10,2) NOT NULL
);

-- Création de la table user 
CREATE TABLE user (
    UserID INT PRIMARY KEY,
    FirstName VARCHAR(100) NOT NULL,
    LastName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    RegistrationDate DATE NOT NULL,
    SubscriptionID INT NOT NULL,
    FOREIGN KEY (SubscriptionID) REFERENCES subscription(SubscriptionID)
);

-- Création de la table movie 
CREATE TABLE movie (
    MovieID INT PRIMARY KEY,
    Title VARCHAR(255) NOT NULL,
    Genre VARCHAR(100) NOT NULL,
    ReleaseYear INT NOT NULL,
    Duration INT NOT NULL,
    Rating VARCHAR(10) NOT NULL
);

-- Création de la table review 
CREATE TABLE review (
    ReviewID INT PRIMARY KEY,
    UserID INT NOT NULL,
    MovieID INT NOT NULL,
    Rating INT NOT NULL,
    ReviewText TEXT NOT NULL,
    ReviewDate DATE NOT NULL,
    FOREIGN KEY (UserID) REFERENCES user(UserID),
    FOREIGN KEY (MovieID) REFERENCES movie(MovieID)
);

-- Création de la table watchhistory 
CREATE TABLE watchhistory (
    WatchHistoryID INT PRIMARY KEY,
    UserID INT NOT NULL,
    MovieID INT NOT NULL,
    WatchDate DATE NOT NULL,
    CompletionPercentage INT NOT NULL,
    FOREIGN KEY (UserID) REFERENCES user(UserID),
    FOREIGN KEY (MovieID) REFERENCES movie(MovieID)
);
-- Insertion des abonnements
INSERT INTO subscription (SubscriptionID, SubscriptionType, MonthlyFee) VALUES
(1, 'Basic', 9.99),
(2, 'Premium', 14.99),
(3, 'Basic', 9.99),
(4, 'Premium', 14.99),
(5, 'Basic', 9.99);

-- Insertion des utilisateurs
INSERT INTO user (UserID, FirstName, LastName, Email, RegistrationDate, SubscriptionID) VALUES
(1, 'Pierre', 'Martin', 'pierre.martin@email.com', '2024-01-15', 1),
(2, 'Marie', 'Durand', 'marie.durand@email.com', '2024-01-20', 2),
(3, 'Jean', 'Bernard', 'jean.bernard@email.com', '2024-02-01', 3),
(4, 'Sophie', 'Lambert', 'sophie.lambert@email.com', '2024-02-10', 4),
(5, 'Lucas', 'Dubois', 'lucas.dubois@email.com', '2024-02-15', 5);

-- Insertion des films
INSERT INTO movie (MovieID, Title, Genre, ReleaseYear, Duration, Rating) VALUES
(1, 'Inception', 'Science Fiction', 2010, 148, 'PG-13'),
(2, 'The Dark Knight', 'Action', 2008, 152, 'PG-13'),
(3, 'Pulp Fiction', 'Crime', 1994, 154, 'R'),
(4, 'Forrest Gump', 'Drama', 1994, 142, 'PG-13'),
(5, 'Matrix', 'Science Fiction', 1999, 136, 'R');

-- Insertion des critiques
INSERT INTO review (ReviewID, UserID, MovieID, Rating, ReviewText, ReviewDate) VALUES
(1, 1, 1, 5, 'Un chef-d''œuvre du cinéma moderne!', '2024-02-01'),
(2, 2, 2, 4, 'Excellent film d''action', '2024-02-05'),
(3, 3, 3, 5, 'Un classique intemporel', '2024-02-10'),
(4, 4, 4, 4, 'Une histoire touchante', '2024-02-15'),
(5, 5, 5, 5, 'Révolutionnaire pour son époque', '2024-02-20');

-- Insertion de l'historique de visionnage
INSERT INTO watchhistory (WatchHistoryID, UserID, MovieID, WatchDate, CompletionPercentage) VALUES
(1, 1, 1, '2024-02-01', 100),
(2, 2, 2, '2024-02-05', 95),
(3, 3, 3, '2024-02-10', 100),
(4, 4, 4, '2024-02-15', 90),
(5, 5, 5, '2024-02-20', 100);


--  Insérer un film : Ajouter un nouveau film intitulé Data Science Adventures dans le genre "Documentary".

INSERT INTO movie (MovieID, Title, Genre, ReleaseYear, Duration, Rating)
VALUES (1, 'Data Science Adventures', 'Documentary', 2024, 120, 'PG');
--fin
-- Rechercher des films : Lister tous les films du genre "Comedy" sortis après 2020

SELECT *
FROM movie
WHERE Genre = 'Comedy' 
AND ReleaseYear > 2020;
---fin

-- Mise à jour des abonnements : Passer tous les utilisateurs de "Basic" à "Premium"..
UPDATE subscription
SET SubscriptionType = 'Premium'
WHERE SubscriptionType = 'Basic';
--fin

--  Afficher les abonnements des utilisateurs :


SELECT  users.FirstName, users.LastName, subscription.SubscriptionType, subscription.MonthlyFee 
FROM users 
INNER JOIN subscription ON users.SubscriptionID = subscription.SubscriptionID;
--fin


-- Filtrer les visionnages : Trouver tous les utilisateurs ayant terminé de regarder un film.

SELECT DISTINCT u.FirstName, u.LastName, m.Title
FROM watchhistory w
JOIN users u ON w.UserID = u.UserID
JOIN movie m ON w.MovieID = m.MovieID
WHERE w.CompletionPercentage = 100;
--fin


-- Trier et limiter : Afficher les 5 films les plus longs, triés par durée.
SELECT Title, Duration, Genre
FROM movie
ORDER BY Duration DESC
LIMIT 5;
--fin


-- Agrégation : Calculer le pourcentage moyen de complétion pour chaque film.


SELECT 
    m.Title,
    AVG(w.CompletionPercentage) as average_completion
FROM movie m
JOIN watchhistory w ON m.MovieID = w.MovieID
GROUP BY m.Title;
--fin



-- Group By : Grouper les utilisateurs par type d’abonnement et compter le nombre total d’utilisateurs par groupe.


SELECT 
    s.SubscriptionType,
    COUNT(u.UserID) as total_users
FROM subscription s
LEFT JOIN user u ON s.SubscriptionID = u.SubscriptionID
GROUP BY s.SubscriptionType;
--fin
