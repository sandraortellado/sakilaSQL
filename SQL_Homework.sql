USE sakila;
SELECT first_name,last_name FROM actor;
SELECT CONCAT(first_name, ' ' ,last_name) AS 'Actor Name' FROM actor;
SELECT first_name,last_name,actor_id FROM actor WHERE first_name = 'Joe';
SELECT first_name,last_name,actor_id FROM actor WHERE last_name LIKE '%GEN%';
-- order by? come back to this
SELECT last_name,first_name FROM actor WHERE last_name LIKE '%LI%';
SELECT country_id,country
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China'); 
ALTER TABLE actor
ADD description BLOB;
ALTER TABLE actor
DROP description;
SELECT count(last_name) AS 'Count',last_name FROM actor GROUP BY last_name;
SELECT count(last_name) AS 'Count',last_name FROM actor GROUP BY last_name HAVING count(last_name) >= 2;
UPDATE sakila.actor
SET    first_name = 'HARPO'
WHERE  first_name = 'GROUCHO' AND last_name = 'WILLIAMS';
UPDATE sakila.actor
SET    first_name = 'GROUCHO'
WHERE  first_name = 'HARPO' AND last_name = 'WILLIAMS';
SHOW CREATE TABLE address;
SELECT first_name, last_name, address
FROM actor
JOIN address ON actor.actor_id = address.address_id;
SELECT staff.staff_id, payment.amount, payment.payment_date
FROM staff
JOIN payment ON staff.staff_id = payment.staff_id GROUP BY staff.staff_id, payment.amount, payment.payment_date
HAVING payment.payment_date LIKE '2005-08%';
SELECT title, count(actor_id) as 'Number of Actors' FROM film
INNER JOIN film_actor ON film.film_id = film_actor.film_id 
GROUP BY title;
SELECT count(film.film_id) AS 'Number of Films',title FROM film
JOIN inventory ON inventory.film_id = film.film_id
WHERE film.title = 'Hunchback Impossible';
SELECT SUM(amount) AS 'Total Paid', customer.last_name from payment
JOIN customer ON payment.customer_id = customer.customer_id
GROUP BY customer.customer_id
ORDER BY last_name;
SELECT title FROM 
(SELECT title FROM film
JOIN language ON language.language_id = film.language_id
WHERE language.language_id = 1) AS english_movies
WHERE title LIKE 'K%' OR title LIKE 'Q%';
SELECT actor.first_name, actor.last_name, film_actor.film_id FROM actor
JOIN film_actor ON actor.actor_id = film_actor.actor_id;
SELECT first_name, last_name, film.title FROM 
(SELECT actor.first_name, actor.last_name, film_actor.film_id FROM actor
JOIN film_actor ON actor.actor_id = film_actor.actor_id) AS actor_names_films
JOIN film ON actor_names_films.film_id = film.film_id
WHERE film.title = 'Alone Trip';
SELECT first_name, last_name, email, country FROM
	(SELECT first_name, last_name, email, country_id FROM 
		(SElECT first_name, last_name, email, city_id FROM customer
		JOIN address on customer.address_id = address.address_id) AS customer_city
	JOIN city ON customer_city.city_id = city.city_id) AS customer_country_id
JOIN country ON customer_country_id.country_id = country.country_id
WHERE country = 'Canada';
SELECT title, name FROM 
		(SElECT title, category_id FROM film
		JOIN film_category on film.film_id = film_category.film_id) AS f_category_id
JOIN category ON f_category_id.category_id = category.category_id
WHERE name = 'Family';
SELECT title, count(rental_date) AS frequency FROM
	(SELECT title,inventory.inventory_id FROM film
JOIN inventory ON inventory.film_id = film.film_id) AS rental_inventory
JOIN rental ON rental_inventory.inventory_id = rental.inventory_id
GROUP BY title
ORDER BY count(rental_date) DESC;
SELECT SUM(amount) AS 'Total Business', store_id FROM
(SELECT store.store_id, customer_id FROM store
JOIN customer ON store.store_id = customer.customer_id) AS store_customer
JOIN payment ON store_customer.customer_id = payment.customer_id
GROUP BY store_id;
SELECT store_id, city, country FROM
(SELECT store_id,city,country_id FROM
(SELECT store.store_id, address.city_id FROM store
JOIN address ON store.address_id = address.address_id) AS store_city_id
JOIN city ON store_city_id.city_id = city.city_id) AS store_city
JOIN country ON store_city.country_id = country.country_id;
SELECT name, sum(amount) AS 'Gross Revenue' FROM
	(SELECT name, customer_id FROM
		(SELECT name, inventory_id FROM
			(SELECT name, film_id FROM category
			JOIN film_category ON film_category.category_id = category.category_id) AS c_name_id
		JOIN inventory ON c_name_id.film_id = inventory.film_id) AS invent_id_byc
	JOIN rental ON invent_id_byc.inventory_id = rental.inventory_id) AS rental_byc
JOIN payment ON rental_byc.customer_id = payment.customer_id
GROUP BY name
ORDER BY sum(amount) DESC
LIMIT 5;
CREATE VIEW top_five_genres AS 
SELECT name, sum(amount) AS 'Gross Revenue' FROM
	(SELECT name, customer_id FROM
		(SELECT name, inventory_id FROM
			(SELECT name, film_id FROM category
			JOIN film_category ON film_category.category_id = category.category_id) AS c_name_id
		JOIN inventory ON c_name_id.film_id = inventory.film_id) AS invent_id_byc
	JOIN rental ON invent_id_byc.inventory_id = rental.inventory_id) AS rental_byc
JOIN payment ON rental_byc.customer_id = payment.customer_id
GROUP BY name
ORDER BY sum(amount) DESC
LIMIT 5;
SELECT * FROM top_five_genres;
DROP VIEW top_five_genres;




