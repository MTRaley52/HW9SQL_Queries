USE sakila;
-- 1a
SELECT first_name, last_name
FROM actor;
-- 1b
SELECT concat(first_name," ",last_name) AS full_name
FROM actor
Order By UPPER(full_name);

-- 2a
select actor_id, first_name, last_name
FROM actor
WHERE first_name = 'Joe';

-- 2b
SELECT concat(first_name," ",last_name) AS full_name
FROM actor
WHERE last_name LIKE '%Gen%';

-- 2c
SELECT first_name,last_name
FROM actor
WHERE last_name LIKE '%LI%'
ORDER BY last_name DESC, first_name ASC;

-- 2d
SELECT country_id, country
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

-- 3a
ALTER TABLE actor
ADD description BLOB(10);

SELECT * FROM actor;

-- 3b
ALTER TABLE actor
DROP COLUMN description;

SELECT * FROM actor;

-- 4a
SELECT last_name, COUNT(*) as 'last_name_count'
from actor
GROUP BY last_name;

-- 4b
SELECT last_name, COUNT(*) as 'last_name_count'
from actor
GROUP BY last_name
HAVING COUNT(last_name) >2
ORDER BY COUNT(last_name) DESC;

-- 4c
UPDATE actor
SET first_name = 'HARPO'
WHERE first_name = 'GROUCHO' AND last_name = 'Williams';

-- 4d
UPDATE actor
SET first_name = 'GROUCHO'
WHERE first_name = 'HARPO' AND last_name = 'Williams';
-- check to make sure it updated:
select * from actor
WHERE first_name = 'GROUCHO' AND last_name = 'Williams';

-- 5a
DESCRIBE sakila.address;

-- 6a
SELECT s.first_name, s.last_name, a.address
FROM staff s LEFT JOIN address a ON s.address_id = a.address_id;
-- last_update does NOT work for join (in both tables)

-- 6b partially works with the dates
SELECT s.first_name, s.last_name, p.payment_date, SUM(p.amount) AS 'Made'
FROM staff s LEFT JOIN payment p ON s.staff_id = p.staff_id
WHERE p.payment_date >= '2005-08-01' and p.payment_date < '2005-09-01'
GROUP BY s.first_name, s.last_name;

-- also tried:
-- SELECT s.first_name, s.last_name, DATE_FORMAT(.payment_date, "%M %d %Y"), SUM(p.amount) AS 'Made'
-- FROM staff s LEFT JOIN payment p ON s.staff_id = p.staff_id
-- WHERE p.payment_date >= 'August 01 2005' and p.payment_date < 'SEPTEMBER 01 2005'
-- GROUP BY s.first_name, s.last_name;




-- check dates: select * from payment order by payment_date DESC
-- check how many staff ids, only two exist: SELECT DISTINCT staff_id from payment;

-- 6c
SELECT f.title, COUNT(fa.actor_id) AS 'Actor Count'
FROM film f
INNER JOIN film_actor fa ON f.film_id = fa.film_id
GROUP BY f.title;

-- 6d
SELECT f.title, COUNT(i.inventory_id) AS 'Inventory'
FROM film f
INNER JOIN inventory i ON f.film_id = i.film_id
WHERE f.title = 'Hunchback Impossible'
GROUP BY f.title;

-- 6e
select c.first_name, c.last_name, SUM(p.amount) AS 'Total Amount Paid'
FROM customer c 
INNER JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.first_name, c.last_name
ORDER BY c.last_name;

-- 7a
-- select * from language
SELECT title 
FROM film
	WHERE language_id IN
    (SELECT language_id
    FROM language
    WHERE name = 'English')
AND title LIKE 'K%' OR title LIKE 'Q%';

-- 7b
SELECT first_name, last_name
FROM actor
WHERE actor_id IN
	(SELECT actor_id FROM film_actor WHERE film_id IN
		(SELECT film_id FROM film WHERE title = 'Alone Trip'));

-- 7c
SELECT cs.first_name, cs.last_name, cs.email
FROM customer cs
JOIN address a ON cs.address_id = a.address_id
JOIN city c ON a.city_id = c.city_id
JOIN country cy ON c.country_id = cy.country_id
WHERE cy.country_id = 20; -- Canada = 20

-- 7d
SELECT f.title, c.name
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Family';

-- 7e
SELECT f.title, COUNT(f.film_id) AS 'Frequency_of_Rentals'
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.title
ORDER BY Frequency_of_Rentals DESC; -- no spaces, need _

-- 7f
SELECT s.store_id, concat('$', FORMAT(SUM(p.amount), 2)) AS 'Revenue'
FROM store s
JOIN staff sf ON s.store_id = sf.store_id
JOIN payment p ON sf.staff_id = p.staff_id
GROUP BY s.store_id;

-- 7g
SELECT s.store_id, c.city, cy.country
FROM store s
JOIN address a ON s.address_id = a.address_id
JOIN city c ON a.city_id = c.city_id
JOIN country cy ON c.country_id = cy.country_id;

-- 7h
SELECT g.name, concat('$', FORMAT(SUM(p.amount), 2)) AS 'Gross_Revenue'
FROM category g
JOIN film_category fc ON g.category_id = fc.category_id
JOIN inventory i ON fc.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id 
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY g.name
ORDER BY Gross_Revenue DESC
LIMIT 5;

-- 8a
CREATE VIEW Top_Five_Genres AS
SELECT g.name, concat('$', FORMAT(SUM(p.amount), 2)) AS 'Gross_Revenue'
FROM category g
JOIN film_category fc ON g.category_id = fc.category_id
JOIN inventory i ON fc.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id 
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY g.name
ORDER BY Gross_Revenue DESC
LIMIT 5;

-- 8b
SELECT * FROM Top_Five_Genres;
-- SELECT * FROM view_name;

-- 8c
DROP VIEW Top_Five_Genres;
-- DROP VIEW view_name;
