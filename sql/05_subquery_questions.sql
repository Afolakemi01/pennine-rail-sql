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
