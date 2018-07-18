USE sakila;

-- 1a. You need a list of all the actors who have Display the first and last names of all actors from the table actor.
SELECT first_name AS `First Name`,
       last_name  AS `Last Name`
FROM actor
ORDER BY 2 ASC;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name. 
SELECT CONCAT(first_name,' ',last_name) AS `Actor Name`
FROM actor
ORDER BY 1 ASC;

-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
SELECT actor_id    AS `Actor ID`,
       first_name  AS `First Name`,
       last_name   AS `Last Name`
FROM actor
WHERE first_name = 'Joe';

-- 2b. Find all actors whose last name contain the letters GEN:
SELECT first_name AS `First Name`,
       last_name  AS `Last Name`
FROM actor
WHERE last_name LIKE '%gen%';

-- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
SELECT first_name  AS `First Name`,
       last_name   AS `Last Name`
FROM actor
WHERE last_name LIKE '%li%'
ORDER BY 2 ASC, 1;

-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
SELECT country_id   AS `Country ID`,
       country      AS `Country`
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

-- 3a. Add a middle_name column to the table actor. Position it between first_name and last_name. Hint: you will need to specify the data type.
ALTER TABLE actor
ADD middle_name VARCHAR(45) 
AFTER first_name;

-- 3b. You realize that some of these actors have tremendously long last names. Change the data type of the middle_name column to blobs.
ALTER TABLE actor
MODIFY COLUMN middle_name blob;

-- 3c. Now delete the middle_name column.
ALTER TABLE actor
DROP COLUMN middle_name;

-- 4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name        AS `Last Name`,
       COUNT(last_name) AS `Total Actors`
FROM actor
GROUP BY 1
ORDER BY 2 DESC;

-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
SELECT last_name        AS `Last Name`,
       COUNT(last_name) AS `Total Actors`
FROM actor
GROUP BY 1
HAVING COUNT(last_name) >= 2
ORDER BY 2 DESC;

-- 4c. Oh, no! The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS, the name of Harpo's second cousin's husband's yoga teacher. Write a query to fix the record.
UPDATE actor
SET first_name = 'HARPO'
WHERE first_name = 'GROUCHO'
  AND last_name = 'WILLIAMS';
  
-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO. Otherwise, change the first name to MUCHO GROUCHO, as that is exactly what the actor will be with the grievous error. BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO MUCHO GROUCHO, HOWEVER! (Hint: update the record using a unique identifier.)
UPDATE actor
SET first_name = IF ((first_name = 'HARPO' AND last_name = 'WILLIAMS'), 'GROUCHO', 'MUCHO GROUCHO')
WHERE first_name = 'HARPO'
  AND last_name = 'WILLIAMS';

-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
DESCRIBE address;

-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
SELECT s.first_name   AS `First Name`,
       s.last_name    AS `Last Name`,
       a.address      AS `Address`
FROM staff   s
JOIN address a ON (a.address_id = s.address_id);

-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment. 
SELECT s.staff_id    AS `Staff ID`,
       s.first_name  AS `First Name`,
       s.last_name   AS `Last Name`,
       SUM(p.amount) AS `Total Amount` 
FROM payment  p
JOIN staff    s ON (p.staff_id = s.staff_id)
GROUP BY 1;

-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
SELECT f.title              AS `Film Title`,
       COUNT(fa.actor_id)   AS `Number of Actors`
FROM film_actor  fa
JOIN film         f ON (fa.film_id = f.film_id)
GROUP BY 1
ORDER BY 2 DESC;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT f.title   AS `Film Title`,
       COUNT(*)  AS `Inventory`
FROM film      f
JOIN inventory i ON (f.film_id = i.film_id)
WHERE f.title = 'Hunchback Impossible';

-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
    -- ![Total amount paid](Images/total_payment.png)

SELECT c.customer_id        AS `Customer ID`,
       c.first_name         AS `First Name`,
       c.last_name          AS `Last Name`,
       sum(p.amount)        AS `Total Payments`
FROM payment  p
JOIN customer c ON (p.customer_id = c.customer_id)
GROUP BY 1
ORDER BY 3 ASC;

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English. 
SELECT title, language_id
FROM film
WHERE (title LIKE 'K%'
   OR title LIKE 'Q%')
  AND language_id = (SELECT language_id
            FROM language
            WHERE name = 'English');

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT a.first_name  AS `First Name`,
       a.last_name   AS `Last Name`
FROM actor       a
JOIN film_actor fa ON (a.actor_id = fa.actor_id)
JOIN film        f ON (fa.film_id = f.film_id)
WHERE f.title = 'Alone Trip';

SELECT first_name, last_name
FROM actor
WHERE actor_id IN
(
  SELECT actor_id
  FROM film_actor
  WHERE film_id IN
  (
   SELECT film_id
   FROM film
   WHERE title = 'Alone Trip'
  )
);


-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
SELECT cu.first_name    AS `First Name`,
       cu.last_name     AS `Last Name`,
       cu.email         AS `Email`
FROM country  co
JOIN city     ci ON (co.country_id = ci.country_id)
JOIN address   a ON (a.city_id = ci.city_id)
JOIN customer cu ON (a.address_id = cu.address_id)
WHERE co.country = 'Canada';

-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as famiy films.
SELECT f.title AS `Family Films`
FROM film           f
JOIN film_category fc ON (f.film_id = fc.film_id)
JOIN category       c ON (fc.category_id = c.category_id)
WHERE c.name = 'Family';

-- 7e. Display the most frequently rented movies in descending order.
SELECT f.title AS `Title`,
       COUNT(*)
FROM rental    r
JOIN inventory i ON (r.inventory_id = i.inventory_id)
JOIN film      f ON (i.film_id = f.film_id)
GROUP BY 1
ORDER BY 2 DESC;

-- 7f. Write a query to display how much business, in dollars, each store brought in.
SELECT str.store_id   AS `Store ID`,
       SUM(p.amount)  AS `Total Sales`
FROM customer cu
JOIN payment   p ON (cu.customer_id = p.customer_id)
JOIN rental    r ON (p.rental_id = r.rental_id)
JOIN staff   stf ON (stf.staff_id = p.staff_id)
JOIN store   str ON (stf.store_id = str.store_id)
GROUP BY 1;

-- 7g. Write a query to display for each store its store ID, city, and country.
SELECT s.store_id AS `Store ID`,
       ci.city    AS `City`,
       co.country AS `Country`
FROM store    s 
JOIN address  a ON (s.address_id = a.address_id)
JOIN city    ci ON (ci.city_id = a.city_id)
JOIN country co ON (ci.country_id = co.country_id)
;

-- 7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
SELECT c.name         AS `Category`,
       SUM(p.amount)  AS `Gross Revenue`
FROM rental         r
JOIN inventory      i ON (r.inventory_id = i.inventory_id)
JOIN payment        p ON (r.rental_id = p.rental_id)
JOIN film_category fc ON (i.film_id = fc.film_id)
JOIN category       c ON (c.category_id = fc.category_id)
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
CREATE VIEW top_genre AS
SELECT c.name         AS `Category`,
       SUM(p.amount)  AS `Gross Revenue`
FROM rental         r
JOIN inventory      i ON (r.inventory_id = i.inventory_id)
JOIN payment        p ON (r.rental_id = p.rental_id)
JOIN film_category fc ON (i.film_id = fc.film_id)
JOIN category       c ON (c.category_id = fc.category_id)
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- 8b. How would you display the view that you created in 8a?
SELECT *
FROM top_genre;

-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
DROP VIEW top_genre;