Create Database ICT_Exam;
Use ICT_Exam;


CREATE TABLE DOCENTE (
    CF_Docente VARCHAR(20) PRIMARY KEY,
    Nome VARCHAR(50) NOT NULL,
    Cognome VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Password VARCHAR(255) NOT NULL
);

CREATE TABLE STUDENTE (
    CF_Studente VARCHAR(20) PRIMARY KEY,
    Nome VARCHAR(50) NOT NULL,
    Cognome VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Password VARCHAR(255) NOT NULL,
    Monete_Totali INT DEFAULT 0,
    ID_Classe INT,
    ID_Videogioco INT,
    FOREIGN KEY (ID_Classe) REFERENCES CLASSI_VIRTUALI(ID_Classe),
    FOREIGN KEY (ID_Videogioco) REFERENCES VIDEOGIOCO(ID_Videogioco)
);

CREATE TABLE CLASSI_VIRTUALI (
    ID_Classe INT PRIMARY KEY AUTO_INCREMENT,
    Anno INT NOT NULL,
    Sezione VARCHAR(10) NOT NULL,
    Corso VARCHAR(50) NOT NULL,
    Codice_Ingresso VARCHAR(100) UNIQUE NOT NULL,
    CF_Docente VARCHAR(20),
    CF_Studente VARCHAR(20),
    ID_Videogioco INT,
    FOREIGN KEY (CF_Docente) REFERENCES DOCENTE(CF_Docente),
    FOREIGN KEY (CF_Studente) REFERENCES STUDENTE(CF_Studente),
    FOREIGN KEY (ID_Videogioco) REFERENCES VIDEOGIOCO(ID_Videogioco)
);

CREATE TABLE CATALOGO (
    ID_Catalogo INT PRIMARY KEY AUTO_INCREMENT,
    Argomento VARCHAR(100) NOT NULL,
    ID_Videogioco INT,
    FOREIGN KEY (ID_Videogioco) REFERENCES VIDEOGIOCO(ID_Videogioco)
);

CREATE TABLE VIDEOGIOCO (
    ID_Videogioco INT PRIMARY KEY AUTO_INCREMENT,
    Titolo VARCHAR(100) NOT NULL,
    Materia VARCHAR(20) NOT NULL,
    Breve_Descrizione VARCHAR(160),
    Descrizione_Estesa TEXT,
    Monete_Ottenibili INT DEFAULT 0,
    ID_Classe INT,
    ID_Studente VARCHAR(20),
    ID_Catalogo INT,
    FOREIGN KEY (ID_Classe) REFERENCES CLASSI_VIRTUALI(ID_Classe),
    FOREIGN KEY (ID_Studente) REFERENCES STUDENTE(CF_Studente),
    FOREIGN KEY (ID_Catalogo) REFERENCES CATALOGO(ID_Catalogo)
);

CREATE TABLE GIOCA (
    CF_Studente VARCHAR(20),
    ID_Videogioco INT,
    Monete_Ottenute INT DEFAULT 0,
    PRIMARY KEY (CF_Studente, ID_Videogioco),
    FOREIGN KEY (CF_Studente) REFERENCES STUDENTE(CF_Studente),
    FOREIGN KEY (ID_Videogioco) REFERENCES VIDEOGIOCO(ID_Videogioco)
);


INSERT INTO DOCENTE (CF_Docente, Nome, Cognome, Email, Password) VALUES
('DOC001', 'Mario', 'Rossi', 'mario.rossi@example.com', 'password123'),
('DOC002', 'Luigi', 'Verdi', 'luigi.verdi@example.com', 'password456'),
('DOC003', 'Anna', 'Bianchi', 'anna.bianchi@example.com', 'password789');

INSERT INTO STUDENTE (CF_Studente, Nome, Cognome, Email, Password, Monete_Totali, ID_Classe, ID_Videogioco) VALUES
('STU001', 'Giulia', 'Ferrari', 'giulia.ferrari@example.com', 'studente123', 50, 1, 1),
('STU002', 'Marco', 'Neri', 'marco.neri@example.com', 'studente456', 30, 1, 2),
('STU003', 'Sara', 'Moretti', 'sara.moretti@example.com', 'studente789', 20, 2, 3);

INSERT INTO CLASSI_VIRTUALI (ID_Classe, Anno, Sezione, Corso, Codice_Ingresso, CF_Docente, CF_Studente, ID_Videogioco) VALUES
(1, 2024, '3B', 'Matematica', 'CODE12345', 'DOC001', 'STU001', 1),
(2, 2024, '4A', 'Scienze', 'CODE67890', 'DOC002', 'STU002', 2),
(3, 2024, '5C', 'Italiano', 'CODE11223', 'DOC003', 'STU003', 3);

INSERT INTO CATALOGO (ID_Catalogo, Argomento, ID_Videogioco) VALUES
(1, 'Triangoli', 1),
(2, 'Legge di Ohm', 2),
(3, 'Verismo', 3);

INSERT INTO VIDEOGIOCO (ID_Videogioco, Titolo, Materia, Breve_Descrizione, Descrizione_Estesa, Monete_Ottenibili, ID_Classe, ID_Studente, ID_Catalogo) VALUES
(1, 'Geometria Facile', 'Matematica', 'Un gioco sui triangoli', 'Approfondisci le proprietà dei triangoli risolvendo quiz.', 100, 1, 'STU001', 1),
(2, 'Circuiti Elettrici', 'Elettronica', 'Legge di Ohm', 'Impara le basi della legge di Ohm con simulazioni pratiche.', 120, 2, 'STU002', 2),
(3, 'Scrittori Italiani', 'Italiano', 'Verismo in letteratura', 'Conosci il Verismo attraverso quiz sui principali autori.', 80, 3, 'STU003', 3);

INSERT INTO GIOCA (CF_Studente, ID_Videogioco, Monete_Ottenute) VALUES
('STU001', 1, 50),
('STU002', 2, 30),
('STU003', 3, 20);

SELECT V.Titolo, C.Argomento
FROM VIDEOGIOCO V
JOIN CATALOGO C ON V.ID_Catalogo = C.ID_Catalogo
WHERE C.Argomento = 'Matematica'
ORDER BY V.Titolo ASC;

SELECT S.Nome, S.Cognome, G.Monete_Ottenute
FROM STUDENTE S
JOIN GIOCA G ON S.CF_Studente = G.CF_Studente
WHERE S.ID_Classe = 1 
  AND G.ID_Videogioco = 1 
ORDER BY G.Monete_Ottenute DESC;

SELECT C.ID_Catalogo, C.Argomento, COUNT(DISTINCT CV.ID_Classe) AS Numero_Classi
FROM CATALOGO C
JOIN VIDEOGIOCO V ON C.ID_Videogioco = V.ID_Videogioco
JOIN CLASSI_VIRTUALI CV ON V.ID_Videogioco = CV.ID_Videogioco
GROUP BY C.ID_Catalogo, C.Argomento;