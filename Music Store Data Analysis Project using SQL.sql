Data Analysis using SQL
      
	

                      Music Store Data Analysis


Q1. Who is the senior employee based on job title?
ANS. Madan Mohan

SELECT * FROM employee
ORDER BY title DESC
LIMIT 1

Q2. Which countries have the most Invoices?
ANS. USA has the most Invoices with the count of 131


SELECT COUNT(*)AS Count,billing_country
FROM invoice
GROUP BY billing_country
ORDER BY Count DESC

Q3.What are the top 3 values of total invoice?
ANS.23.75
	19.8
	19.8
	
SELECT total FROM invoice
ORDER BY total DESC
LIMIT 3

Q4: Which city has the best customers ? We WOUld like to throw a 
promotional Music Festival in the city we made the most money. Write a 
query that returns one city that has the highest sum of invoice totals. 
Return both the city name & sum of all invoice totals 
 
SELECT SUM(Total) as invoice_total,billing_city
FROM invoice 
GROUP BY billing_city
ORDER BY invoice_total DESC

Q5: Who is the best customer? The customer who has spent the most 
money will be declared the best customer. Write a query that returns 
the Derson who has soent the most money.

SELECT customer.customer_id,customer.first_name,customer.last_name, SUM(invoice.total) AS total FROM customer
JOIN invoice ON customer.customer_id=invoice.customer_id
GROUP BY customer.customer_id
ORDER BY total DESC
limit 1








Q5. Write query to return the email, first name, last name, & Genre 
of all Rock Music listeners. Return your list ordered alphabetically 
by email startinq with A 


SELECT DISTINCT email,first_name,last_name FROM customer
JOIN invoice ON customer.customer_id=invoice.customer_id 
JOIN invoice_line ON invoice.invoice_id=invoice_line.invoice_id
WHERE track_id IN(
SELECT track_id  FROM track
JOIN genre ON track.genre_id=genre.genre_id
WHERE genre.name='Rock')
ORDER BY email;



SELECT * FROM track 

Q6. Write query to return the email, first name, last name, & Genre 
of all Rock Music listeners. Return your list ordered alphabetically 
by email startinq with A 


SELECT DISTINCT email,first_name,last_name FROM customer
JOIN invoice ON customer.customer_id=invoice.customer_id 
JOIN invoice_line ON invoice.invoice_id=invoice_line.invoice_id
WHERE track_id IN(
SELECT track_id  FROM track
JOIN genre ON track.genre_id=genre.genre_id
WHERE genre.name='Rock')
ORDER BY email;


Q7.Lets invite the artists who have written the most rock music in 
our dataset. Write a query that returns the Artist name and total 
track count of the top 10 rock bands

SELECT artist.artist_id,artist.name,COUNT(artist.artist_id) AS number_of_songs FROM track
JOIN album ON album.album_id=track.album_id
JOIN artist ON artist.artist_id=album.artist_id
JOIN genre 	ON genre.genre_id=track.genre_id
WHERE genre.name LIKE 'Rock'
GROUP BY artist.artist_id
ORDER BY number_of_songs DESC

SELECT * FROM track

Q8: Return all the track names that have a song length longer than 
the average song length. Return the Name and Milliseconds for 
each track. Order by the song length with the longest songs listed 
first. 

SELECT name,milliseconds FROM track
WHERE milliseconds > (SELECT AVG(milliseconds) AS avg_song_length FROM track)
ORDER BY milliseconds DESC

Q9: Find how much amount spent by each customer on artists? Write a 
query to return customer name, artist name and total spent 

WITH bsa AS (SELECT artist.artist_id,artist.name,SUM(invoice_line.quantity*invoice_line.unit_price) AS Total_sales
			FROM invoice_line
			JOIN track ON track.track_id=invoice_line.track_id
			 JOIN album ON album.album_id=track.album_id
			 JOIN artist ON artist.artist_id=album.artist_id
			GROUP BY 1
			ORDER BY 3 DESC
			 LIMIT 1
			)
			SELECT c.customer_id,c.first_name,c.last_name,bsa.name,SUM(il.quantity*il.unit_price) AS Amount_spent
			FROM invoice i
			JOIN customer c ON c.customer_id=i.customer_id
			JOIN invoice_line il ON il.invoice_id=i.invoice_id
			JOIN track t ON t.track_id=il.track_id
			JOIN album alb ON alb.album_id= t.album_id
			JOIN bsa ON bsa.artist_id=alb.artist_id
			GROUP BY 1,2,3,4
			ORDER BY 5 DESC;
			
SELECT * FROM invoice_line

Q10: We want to find out the most popular music Genre for each country. 
We determine the most popular genre as the genre with the highest 
amount of purchases. Write a query that returns each country along with 
the top Genre. For countries where the maximum number of p 
is shared return all Genres.

WITH popular_genre AS (SELECT COUNT (invoice_line.quantity) AS purchases, customer.country,genre.genre_id,genre.name,
				 			ROW_NUMBER() OVER(PARTITION BY customer.country ORDER BY COUNT(invoice_line.quantity)DESC) AS RowNo 
				 			FROM invoice_line			
							JOIN invoice ON invoice.invoice_id=invoice_line.invoice_id
							JOIN customer ON customer.customer_id = invoice.customer_id
							JOIN track ON track.track_id=invoice_line.track_id
							JOIN genre ON genre.genre_id=track.genre_id
							GROUP BY 2,3,4
							ORDER BY 2 ASC,1 DESC
							)
							SELECT * FROM popular_genre WHERE RowNo <= 1


Q.11 :Write a query that determines the customer that has spent the most 
on music for each country. Write a query that returns the country along 
with the top customer and how much they spent. For countries where 
the top amount spent is shared, provide all customers who spent this 
amount 
 
WITH Customer_with_Country AS (SELECT customer.customer_id,customer.first_name,customer.last_name,invoice.billing_country,SUM(total) AS total_spending,
							   ROW_NUMBER() OVER(PARTITION BY billing_country ORDER BY SUM(total)DESC) RowNo
												FROM invoice
							   JOIN customer ON customer.customer_id=invoice.customer_id
							   GROUP BY 1,2,3,4
							   ORDER BY 4 ASC,5 DESC)
							   SELECT * FROM Customer_with_Country WHERE RowNo>= 1
							  
							


