-- B1. Which sales channels sell Advance tickets?
-- Requirements:
--   1. Show sales_channel.
--   2. Only Advance tickets.
--   3. List each channel once.
--   4. Sort alphabetically.
SELECT DISTINCT sales_channel
FROM tickets
WHERE ticket_type = 'Advance'
ORDER BY sales_channel;
-- Result: Advance tickets are sold only through the App and the Website; none are sold at stations.

-- B2. Which routes have First class ticket sales?
-- Requirements:
--   1. Show origin and destination.
--   2. Only First class tickets.
--   3. List each route once.
--   4. Sort by origin, then destination.
SELECT DISTINCT origin, destination
FROM tickets
WHERE travel_class = 'First'
ORDER BY origin, destination;
-- Result: First class tickets were sold on 6 routes, and every one starts or ends in Leeds or York.

-- B3. Which refunded tickets were bought at a station or on the website?
-- Requirements:
--   1. Show ticket_id, sales_channel and price_gbp.
--   2. Only refunded tickets.
--   3. Only tickets bought at a station or on the website.
--   4. Most expensive first.
--   5. If two cost the same, lower ticket_id first.
SELECT ticket_id, sales_channel, price_gbp
FROM tickets
WHERE (sales_channel = 'Station' OR sales_channel = 'Website')
  AND ticket_status = 'Refunded'
ORDER BY price_gbp DESC, ticket_id;
-- Result: Six refunded tickets match; the two most expensive (£51.00 and £31.50) were both bought at a station.

-- B4. Which Off-Peak journeys to or from Manchester cost more than £10 (in pence)?
-- Requirements:
--   1. Show ticket_id, origin, destination, and price in pence as price_pence.
--   2. Only Off-Peak tickets.
--   3. Only journeys to or from Manchester.
--   4. Only tickets costing more than £10.
--   5. Cheapest first.
--   6. If two cost the same, lower ticket_id first.
SELECT ticket_id, origin, destination, price_gbp * 100 AS price_pence
FROM tickets
WHERE (origin = 'Manchester' OR destination = 'Manchester')
  AND ticket_type = 'Off-Peak'
  AND price_gbp > 10.00
ORDER BY price_pence, ticket_id;
-- Result: Six tickets match, from 1,350p (three Sheffield to Manchester tickets) to 2,400p (York to Manchester).

-- B5. What are the 2 most expensive Adult, Standard class tickets that were not refunded?
-- Requirements:
--   1. Show ticket_id, origin, destination, ticket_type and price_gbp.
--   2. Only Adult tickets.
--   3. Only Standard class tickets.
--   4. Exclude refunded tickets.
--   5. Most expensive first; if two cost the same, lower ticket_id first.
--   6. Return the top 2, plus a 3rd row to check for a tie at the cut-off.
SELECT ticket_id, origin, destination, ticket_type, price_gbp
FROM tickets
WHERE travel_class = 'Standard'
  AND passenger_type = 'Adult'
  AND ticket_status <> 'Refunded'
ORDER BY price_gbp DESC, ticket_id
LIMIT 3;
-- Result: 2nd and 3rd place are tied at £22.00 (tickets 44 and 45, both Leeds to Manchester Anytime), so a strict top 2 would drop one arbitrarily; both should be reported to the manager.
