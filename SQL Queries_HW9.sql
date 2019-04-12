USE sakila;
-- 1a
SELECT first_name, last_name
FROM actor;
-- 1b
SELECT concat(first_name," ",last_name) AS full_name
FROM actor
Order By UPPER(full_name);
