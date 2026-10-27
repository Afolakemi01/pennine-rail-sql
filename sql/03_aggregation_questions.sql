-- A1. Which sales channel brings in the most revenue?
SELECT sales_channel, COUNT(*) AS tickets_sold, SUM(price_gbp) AS revenue_gbp
FROM tickets
WHERE ticket_status = 'Completed'
GROUP BY sales_channel
ORDER BY revenue_gbp DESC;
-- Result: Website brings in the most revenue (£237.50 from 20 tickets), £16.00 ahead of App (£221.50, also 20 tickets); Station is lowest (£163.50 from 12 tickets).

-- A2. Which routes sold at least 3 tickets?
SELECT origin, destination, COUNT(*) AS tickets_sold
FROM tickets
GROUP BY origin, destination
HAVING COUNT(*) >= 3
ORDER BY tickets_sold DESC, origin, destination;
-- Result: The routes from York to Leeds and York to Manchester are the busiest, with 7 tickets sold each. These are followed by Leeds to Huddersfield and Huddersfield to Leeds, with 6 tickets sold each. The least busy routes in this threshold are Leeds to Manchester, Manchester to Huddersfield, Manchester to Leeds, and Sheffield to York, with 3 tickets sold each.

-- A3. How satisfied are customers with their journeys?
SELECT
CASE
    WHEN customer_rating >= 4 AND customer_rating <= 5 THEN 'Satisfied'
    WHEN customer_rating = 3 THEN 'Neutral'
    WHEN customer_rating >= 1 AND customer_rating <= 2 THEN 'Dissatisfied'
    WHEN customer_rating IS NULL THEN 'No response'
    ELSE 'Invalid'
    END AS rating_band,
Count(*) AS tickets
FROM tickets
GROUP BY CASE
    WHEN customer_rating >= 4 AND customer_rating <= 5 THEN 'Satisfied'
    WHEN customer_rating = 3 THEN 'Neutral'
    WHEN customer_rating >= 1 AND customer_rating <= 2 THEN 'Dissatisfied'
    WHEN customer_rating IS NULL THEN 'No response'
    ELSE 'Invalid'
    END
ORDER BY tickets DESC;
-- Result: Of 60 tickets, 31 were rated Satisfied, 6 Neutral and 4 Dissatisfied; 18 had no survey response and 1 had an invalid rating (outside 1–5).

-- A4. How many tickets in each travel class received a survey response?
SELECT travel_class, COUNT(*) AS tickets, COUNT(customer_rating) AS responses, COUNT(*) - COUNT(customer_rating) AS no_response
FROM tickets
GROUP BY travel_class
ORDER BY travel_class;
-- Result: First class: 12 tickets, 6 survey responses, 6 no response (50% response rate). Standard: 48 tickets, 36 responses, 12 no response (75% response rate).

-- A5. What is the average customer rating for each travel class?
SELECT travel_class,
    COUNT(customer_rating) AS ratings_used,
    ROUND(AVG(customer_rating), 2) AS avg_rating
FROM tickets
WHERE customer_rating >= 1 AND customer_rating <= 5
GROUP BY travel_class
ORDER BY travel_class;
-- Result: First Class tickets have an average customer rating of 3.50, based on 6 survey responses, while Standard Class tickets have an average rating of 3.91, based on 35 valid survey responses.

