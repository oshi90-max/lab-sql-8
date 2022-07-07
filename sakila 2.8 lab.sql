USE sakila;

----- Write a query to display for each store its store ID, city, and country.
SELECT S.store_id AS 'store id', C.city, CN.country
FROM address A
JOIN store S
ON A.address_id=S.address_id
JOIN city C
ON C.city_id=A.city_id
JOIN country CN
ON CN.country_id=C.country_id
;

----- Write a query to display how much business, in dollars, each store brought in.
SELECT SR.store_id, sum(P.amount) AS 'total amount of business'
FROM store SR
JOIN staff SF
ON SR.store_id=SF.store_id
JOIN payment P
ON SF.staff_id=P.staff_id
GROUP BY store_id
;

----- Which film categories are longest?
SELECT SUM(F.length) AS 'how long? (in minutes)', C.name AS 'category'
FROM film F
JOIN film_category FC
ON F.film_id=FC.film_id
JOIN category C
ON C.category_id=FC.category_id
GROUP BY C.name
ORDER BY SUM(F.length) desc
LIMIT 5
;

----- Display the most frequently rented movies in descending order
SELECT SUM(P.amount) 'how much they were rented (in dollars)', F.title AS 'movie title' 
FROM payment P
JOIN rental R
ON R.rental_id=P.rental_id
JOIN inventory I
ON I.inventory_id=R.inventory_id
JOIN film F
ON F.film_id=I.film_id
GROUP BY F.title
ORDER BY SUM(P.amount) desc
;

----- List the top five genres in gross revenue in descending order.
SELECT C.name as 'genres', SUM(P.amount) 'grosss revenue'
FROM payment P
JOIN rental R USING (rental_id)
INNER JOIN inventory I USING (inventory_id)
INNER JOIN film F USING (film_id)
INNER JOIN film_category FC USING (film_id)
INNER JOIN category C USING (category_id)
GROUP BY C.name
ORDER BY SUM(P.amount) desc
LIMIT 5
;

----- Is "Academy Dinosaur" available for rent from Store 1?
SELECT F.title
FROM film F
JOIN inventory I USING (film_id)
INNER JOIN store S USING (store_id)
WHERE F.title LIKE '%Academy Dinosaur%' AND S.store_id=1
;

----- Get all pairs of actors that worked together
SELECT A1.actor_id AS 'actor id (1)', A2.actor_id AS 'actor id (2)', A1.film_id AS 'film id'
FROM film_actor A1
JOIN film_actor A2
ON (A1.actor_id <> A2.actor_id) AND (A1.film_id = A2.film_id)
ORDER BY A1.film_id;

SELECT A.first_name, A.last_name, A1.film_id      -- dousnt work
FROM actor A
INNER JOIN film_actor A1
JOIN film_actor A2
ON (A1.actor_id <> A2.actor_id) AND (A1.film_id = A2.film_id)
ORDER BY A1.film_id;

----- Get all pairs of customers that have rented the same film more than 3 times.
SELECT R1.customer_id AS 'customer 1', R2.customer_id AS 'customer 2', COUNT(distinct R1.inventory_id) AS 'number of films'
FROM rental R1 JOIN
     rental R2
     ON (R1.inventory_id = R2.inventory_id) AND (R1.customer_id <> R2.customer_id)
GROUP BY R1.customer_id
ORDER BY ('number of films' >3) desc ;

----- For each film, list actor that has acted in more films

SELECT fa.film_id, f.title, a.first_name, a.last_name
FROM actor a
RIGHT JOIN film_actor fa USING(actor_id)
JOIN film f USING(film_id);



SELECT title
FROM film 
WHERE film_id IN (
SELECT film_id 
FROM film_actor
WHERE actor_id IN (
SELECT actor_id 
FROM actor 
WHERE actor_id IN (
SELECT actor_id 
FROM film_actor GROUP BY actor_id 
HAVING COUNT(actor_id)>1)));




SELECT * 
FROM rental;