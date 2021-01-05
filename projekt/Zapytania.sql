/*1.	Wyświetla imię i nazwisko artystów których albumy znajdują się w bazie.*/
CREATE VIEW Zapytanie_1 AS
SELECT DISTINCT ID_wykonawcy, CONCAT(imię," ", nazwisko) AS "imię i nazwisko", nazwa_albumu
FROM wykonawcy JOIN albumy_solowe ON wykonawcy.pseudonim=albumy_solowe.autor
GROUP BY ID_wykonawcy;

/*2.	Wyświetla ile piosenek danego zespołu znajduje się w bazie.*/
CREATE VIEW Zapytanie_2 AS
SELECT ID_zespołu, nazwa_zespołu, count(nazwa_utworu) AS liczba_piosenek
FROM zespoły LEFT JOIN utwory_zespołów ON zespoły.nazwa_zespołu=utwory_zespołów.autor
GROUP BY ID_zespołu;

/*3.	Wyświetla wykonawców, którzy nie mają przypisanego zespołu w bazie.*/
CREATE VIEW Zapytanie_3 AS
SELECT pseudonim, imię, nazwisko
FROM wykonawcy
WHERE zespół IS NULL;

/*4.	Średni wiek członków zespołów.*/
CREATE VIEW Zapytanie_4 AS
SELECT nazwa_zespołu, liczba_członków, AVG(wiek) AS "Średni wiek członków zespołu"
FROM zespoły LEFT JOIN wykonawcy ON zespoły.nazwa_zespołu=wykonawcy.zespół
GROUP BY ID_zespołu;

/*5.	Ile utworów wyszło w danej wytwórni.*/
CREATE VIEW Zapytanie_5 AS
SELECT ID_wytwórni, nazwa_wytwórni, count(utwory_solowe.nazwa_utworu)+count(distinct utwory_zespołów.nazwa_utworu) AS ilość_utworów
FROM wytwórnie LEFT JOIN zespoły ON wytwórnie.nazwa_wytwórni=zespoły.wytwórnia LEFT JOIN wykonawcy ON  wytwórnie.nazwa_wytwórni=wykonawcy.wytwórnia LEFT JOIN utwory_solowe ON wykonawcy.pseudonim=autor LEFT JOIN utwory_zespołów ON zespoły.nazwa_zespołu=utwory_zespołów.autor
GROUP BY ID_wytwórni;

/*6.	Muzyków którzy urodzili się w 1990 lub później, posługują się pseudonimem artystycznym oraz liczbę wydanych przez nich utworów.*/
CREATE VIEW Zapytanie_6 AS
SELECT ID_wykonawcy, pseudonim, imię, nazwisko, data_ur, count(utwory_solowe.nazwa_utworu)+count(distinct utwory_zespołów.nazwa_utworu) AS ilość_utworów
FROM wykonawcy LEFT JOIN utwory_solowe ON wykonawcy.pseudonim=utwory_solowe.autor LEFT JOIN zespoły ON wykonawcy.zespół=zespoły.nazwa_zespołu LEFT JOIN utwory_zespołów ON zespoły.nazwa_zespołu=utwory_zespołów.autor
WHERE YEAR(data_ur)>=1990 AND pseudonim IS NOT NULL
GROUP BY ID_wykonawcy;

/*7.	Albumy wydane przed 2020 rokiem.*/
CREATE VIEW Zapytanie_7 AS
SELECT nazwa_albumu, autor, rok_wydania, liczba_utworów FROM albumy
WHERE rok_wydania<2020
UNION
SELECT nazwa_albumu, autor, rok_wydania, liczba_utworów FROM albumy_solowe
WHERE rok_wydania<2020;

/*8.	Zespoły, rok założenia i ich członków z wiekiem.*/
CREATE VIEW Zapytanie_8 AS
SELECT nazwa_zespołu, rok_założenia AS "rok założenia zespołu", CONCAT(imię," ",nazwisko) AS "imię i nazwisko", wiek
FROM zespoły LEFT JOIN wykonawcy ON zespoły.nazwa_zespołu=wykonawcy.zespół
WHERE wykonawcy.zespół IS NOT NULL;

/*9.	Zespoły powstałe po 2000 roku mające więcej niż 2 członków, które mają co najmniej 12 piosenek w bazie.*/
CREATE VIEW Zapytanie_9 AS
SELECT id_zespołu, nazwa_zespołu, rok_założenia, liczba_członków, count(nazwa_utworu) AS liczba_piosenek
FROM zespoły LEFT JOIN utwory_zespołów ON zespoły.nazwa_zespołu=utwory_zespołów.autor
WHERE rok_założenia>2000 AND liczba_członków>2
HAVING liczba_piosenek>12;

/*10.	Wybiera 10 losowych piosenek z bazy.*/
CREATE VIEW Zapytanie_10 AS
SELECT * from utwory_solowe
UNION
SELECT * FROM utwory_zespołów
ORDER BY rand() LIMIT 10;
