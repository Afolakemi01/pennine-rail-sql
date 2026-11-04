-- Pennine Rail: subquery and CTE questions
-- Two-step business questions answered with scalar subqueries, IN / NOT EXISTS,
-- derived tables and CTEs, plus a fan-out fix for multi-count reports.

-- S1. Which tickets sold for more than the average price of all our tickets?
SELECT ticket_id, origin, destination, price_gbp,
     (SELECT ROUND(AVG(price_gbp), 2)
     FROM tickets) AS network_avg_price
FROM tickets
WHERE price_gbp > (SELECT AVG(price_gbp) FROM tickets)
ORDER BY price_gbp DESC, ticket_id;
-- Result: 29 tickets sold for more than the overall average ticket price of £12.61. Prices ranged from £13.50 to £51.00, with ticket_id 51 (York–Manchester) being the most expensive at £51.00.

-- S2. Which stations have had at least one departing ticket rated between 1 and 2 stars?
SELECT station_code, station_name
FROM stations
WHERE station_name IN
    (SELECT origin
    FROM tickets
    WHERE customer_rating >= 1 AND customer_rating <= 2)
ORDER BY station_name;
-- Result: 3 stations have had at least one departing ticket rated 1–2 stars: Huddersfield, Leeds and Manchester.

-- S3a. Operations wants the stations that no station uses as its hub.
SELECT station_code, station_name
FROM stations
WHERE station_code NOT IN (SELECT hub_station_code FROM stations)
ORDER BY station_name;
-- Result: 0 rows. NOT IN returns nothing because hub_station_code contains NULL (see S3b).

-- S3b. NOT EXISTS:
SELECT s.station_code, s.station_name
FROM stations s
WHERE NOT EXISTS
    (SELECT 1
    FROM stations h
    WHERE s.station_code = h.hub_station_code)
ORDER BY station_name;
-- Result: Five stations (Bradford, Huddersfield, Sheffield, Wakefield and York) are not used as hub stations by any station. These are the stations with no stations depending on them as a hub.

-- S4. On average, how many tickets does one station sell as departures, and how many stations went into that average?
SELECT
    COUNT(*) AS stations_counted,
    ROUND(AVG(departures), 1) AS avg_departures_per_station
FROM (
    SELECT
        origin,
        COUNT(*) AS departures
    FROM tickets
    GROUP BY origin
) AS origin_summary;
-- Result: 5 origin stations averaged 12.0 departures each (5 × 12.0 = 60 tickets).

-- S5. Which departure stations have a worse average customer rating than the network as a whole?
WITH station_ratings AS (
    SELECT origin,
        COUNT(customer_rating) AS rated_tickets,
        AVG(customer_rating) AS avg_rating
    FROM tickets
    GROUP BY origin
)
SELECT origin, rated_tickets, ROUND(avg_rating, 2) AS avg_rating,
    (SELECT ROUND(AVG(customer_rating), 2) FROM tickets) AS network_avg_rating
FROM station_ratings
WHERE avg_rating < (
    SELECT AVG(customer_rating)
    FROM tickets)
ORDER BY avg_rating;
-- Result: 2 origin stations are rated below the network average of 3.76: Huddersfield (3.17 from 6 ratings) and Sheffield (3.57 from 7 ratings).



















WITH stations_counted AS(
    SELECT s.station_name, COUNT(t.ticket_id) AS per_station
    FROM stations s
    JOIN tickets t
    ON s.station_name = t.origin
    GROUP BY s.station_name
)

SELECT s.station_name, AVG(sc.per_station) AS per_station
FROM stations s
JOIN stations_counted sc
ON s.station_name = sc.station_name
GROUP BY s.station_name;
