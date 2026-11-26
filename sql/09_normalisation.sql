-- Functional dependencies
-- tickets:
-- ticket_id -> purchase_date, travel_date, origin, destination, ticket_type, travel_class, passenger_type, sales_channel, price_gbp, ticket_status, customer_rating

-- stations:
-- station_name -> station_code, region_code, hub_station_code
-- station_code -> station_name, region_code, hub_station_code

-- regions:
-- region_code -> region_name, regional_manager

-- Normal-form review
-- 1NF: every column holds a single value; no lists or repeating groups.
-- 2NF and 3NF: every determinant is a candidate key, so every non-key column
-- depends on a whole candidate key, not on part of one or on a non-key column.
-- Verdict: tickets, stations and regions are all in 3NF.

-- Does the same route and ticket combination ever have different prices?
SELECT
    origin,
    destination,
    ticket_type,
    travel_class,
    passenger_type,
    COUNT(DISTINCT price_gbp) AS different_prices
FROM tickets
GROUP BY
    origin,
    destination,
    ticket_type,
    travel_class,
    passenger_type
HAVING COUNT(DISTINCT price_gbp) > 1;
-- Result: 0 rows. In the current data each route/ticket combination has one price,
-- but only 11 of the 47 combinations occur more than once, so this does not prove the FD.
-- Decision: price_gbp stays on tickets. It records the price paid at purchase; fares change
-- over time, so it is a historical value, not a dependency on the route.
