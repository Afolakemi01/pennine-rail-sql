-- W1: What share of each ticket type's revenue comes from each sales channel?
WITH channel_revenue AS (
    SELECT
        ticket_type,
        sales_channel,
        SUM(price_gbp) AS revenue_gbp
    FROM tickets
    WHERE ticket_status = 'Completed'
    GROUP BY ticket_type, sales_channel
)
SELECT ticket_type,
    sales_channel,
    revenue_gbp,
    ROUND(100 * revenue_gbp / SUM(revenue_gbp) OVER(PARTITION BY ticket_type), 1) AS pct_of_type
FROM channel_revenue
ORDER BY ticket_type, pct_of_type DESC;
-- Result: Advance revenue comes mainly from the Website (63.1%), Anytime from the App (46.2%), while Off-Peak relies most on Station sales (45.7%).

-- W2: How did completed station-sale revenue build up over time?
SELECT ticket_id,
    purchase_date,
    price_gbp,
    SUM(price_gbp) OVER(ORDER BY purchase_date ASC, ticket_id) AS running_revenue_gbp
FROM tickets
WHERE sales_channel = 'Station'
    AND ticket_status = 'Completed'
ORDER BY purchase_date ASC, ticket_id;
-- Result: Completed station sales generated £163.50 across 12 tickets between 29 September and 11 October 2026, with the running revenue increasing as each ticket was purchased.

-- W3: What is the 3-day moving average of completed revenue by travel date?
WITH daily_revenue AS (
    SELECT travel_date,
    SUM(price_gbp) AS revenue_gbp
FROM tickets
WHERE ticket_status = 'Completed'
GROUP BY travel_date
)
SELECT travel_date,
    revenue_gbp,
    ROUND(AVG(revenue_gbp) OVER(ORDER BY travel_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 2) AS moving_avg_3day_gbp
FROM daily_revenue
ORDER BY travel_date ASC;
-- Result: Daily completed revenue ranged from £6.00 to £93.50 (1–14 October 2026); the 3-day moving average peaked at £71.33 on 11 October. The final days are low because the data only covers tickets bought up to 13 October.
