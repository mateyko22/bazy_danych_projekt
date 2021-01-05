/* Przenoszą usunięte utwory do archiwum*/
DELIMITER $$
CREATE TRIGGER archiwum BEFORE DELETE ON utwory_solowe
FOR EACH ROW
INSERT INTO archiwum VALUES(old.ID_utworu, old.nazwa_utworu, old.autor, old.album,CURRENT_DATE());
END $$;

DELIMITER $$
CREATE TRIGGER archiwum_zesp BEFORE DELETE ON utwory_zespołów
FOR EACH ROW
INSERT INTO archiwum VALUES(old.ID_utworu, old.nazwa_utworu, old.autor, old.album,CURRENT_DATE());
END $$;

/*Po dodaniu utworu do bazy powiększa liczbę utworów w tabeli album.*/
DELIMITER $$
CREATE TRIGGER albumy_liczba_utw BEFORE INSERT ON utwory_solowe
FOR EACH ROW
BEGIN
UPDATE albumy_solowe
SET liczba_utworów = liczba_utworów + 1
WHERE nazwa_albumu=new.album;
END $$;

DELIMITER $$
CREATE TRIGGER albumy_liczba_utw_z BEFORE INSERT ON utwory_zespołów
FOR EACH ROW
BEGIN
UPDATE albumy
SET liczba_utworów = liczba_utworów + 1
WHERE nazwa_albumu=new.album;
END $$;

/* Procedura, zwraca liczbę wykonawców, zespołów, albumów i utworów znajdujących się w bazie.*/
DELIMITER //
CREATE PROCEDURE łącznie()
BEGIN
	SELECT (SELECT count(*) FROM wykonawcy) AS "Liczba wykonawców", (SELECT count(*) FROM zespoły) AS "Liczba zespołów", (SELECT count(*) FROM albumy) + (SELECT count(*) from albumy_solowe) AS "Liczba albumów",
	(SELECT count(*) FROM utwory_zespołów) + (SELECT count(*) from utwory_solowe) AS "Łączna liczba utworów";
END //;

/* Funkcje dodające utwór i zespół do bazy.*/
DELIMITER //
CREATE FUNCTION dodaj_utwór (nazwa_utworu VARCHAR(50), autor VARCHAR(30), album VARCHAR(40))
RETURNS text DETERMINISTIC
BEGIN
INSERT INTO utwory_solowe(ID_utworu, nazwa_utworu, autor, album) VALUES (null, nazwa_utworu, autor, album);
RETURN "Pomyślnie dodano.";
END //;

DELIMITER //
CREATE FUNCTION dodaj_zespół (nazwa_zespołu VARCHAR(30), rok_założenia YEAR, liczba_członków int)
RETURNS text DETERMINISTIC
BEGIN
INSERT INTO zespoły(ID_zespołu, nazwa_zespołu, rok_założenia, liczba_członków, wytwórnia) VALUES (null, nazwa_zespołu, rok_założenia, liczba_członków, null);
RETURN "Pomyślnie dodano.";
END //