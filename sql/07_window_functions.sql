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

-- W4: What are the two highest completed-ticket prices from each origin, and which tickets were sold at them?
WITH ranked_prices AS (
    SELECT origin,
        ticket_id,
        price_gbp,
        -- DENSE_RANK: tied tickets share one price point, so a tie must not use up the second slot (RANK would skip to 3 and drop Leeds' £17.00).
        DENSE_RANK() OVER(PARTITION BY origin ORDER BY price_gbp DESC) AS price_rank
    FROM tickets
    WHERE ticket_status = 'Completed'
    )
SELECT origin,
    ticket_id,
    price_gbp,
    price_rank
FROM ranked_prices
WHERE price_rank <= 2
ORDER BY origin, price_gbp DESC, ticket_id;
-- Result: 11 tickets across 5 origins; Manchester has the highest top price (£33.00), and Leeds has two tickets tied at £22.00 before its second price point of £17.00.

-- W5: What was the most recent ticket sold from each origin station?
-- One window per origin; tickets ordered by latest purchase date and highest ticket ID; returns one row per origin (5 rows).
WITH origin_recent AS (
    SELECT origin,
        ticket_id,
        destination,
        ticket_status,
        purchase_date,
        -- ROW_NUMBER: exactly one latest ticket per origin is wanted; unlike RANK or DENSE_RANK, it never gives two rows the same number.
        ROW_NUMBER() OVER(
            PARTITION BY origin
            ORDER BY purchase_date DESC, ticket_id DESC) AS recency_rank
    FROM tickets
)
SELECT origin,
    ticket_id,
    purchase_date,
    destination,
    ticket_status
FROM origin_recent
WHERE recency_rank = 1
ORDER BY origin;
-- Result: The results identify the most recently sold ticket from each of the five origin stations. Four latest tickets were completed, while Huddersfield's latest ticket (ID 55, sold on 10 October 2026) was refunded. Leeds had the most recent sale overall, on 13 October 2026.

-- W6: How did completed revenue change from one purchase month to the next?
WITH monthly_revenue AS(
    SELECT DATE_TRUNC('month', purchase_date)::DATE AS purchase_month,
        COUNT(*) AS tickets,
        SUM(price_gbp) AS revenue_gbp
    FROM tickets
    WHERE ticket_status = 'Completed'
    GROUP BY DATE_TRUNC('month', purchase_date)::DATE
    )
SELECT purchase_month,
    tickets,
    revenue_gbp,
    LAG(revenue_gbp) OVER(ORDER BY purchase_month) AS prev_month_revenue_gbp,
    revenue_gbp - LAG(revenue_gbp) OVER(ORDER BY purchase_month) AS change_gbp
FROM monthly_revenue
ORDER BY purchase_month;
-- Result: Completed-ticket revenue increased from £220.00 in September 2026 to £402.50 in October 2026, representing a month-on-month increase of £182.50. September has no previous-month revenue or change because it is the first month in the results.

-- W7: Which origin stations had a week with no ticket sales between weeks with sales?
-- One window per origin; counts all tickets sold in each week; each output row represents a gap between weeks with sales.
WITH weekly_sales AS(
    SELECT origin,
        DATE_TRUNC('week', purchase_date)::DATE AS sales_week,
        COUNT(ticket_id) AS tickets_sold
    FROM tickets
    GROUP BY origin, DATE_TRUNC('week', purchase_date)::DATE
),
prev_weekly_sales AS (
    SELECT origin,
        sales_week,
        tickets_sold,
        LAG(sales_week) OVER(PARTITION BY origin ORDER BY sales_week) AS prev_sales_week
    FROM weekly_sales),
week_checks AS(
    SELECT origin,
        sales_week,
        prev_sales_week,
        CASE
            WHEN prev_sales_week IS NULL THEN 'first week'
            WHEN prev_sales_week = sales_week - INTERVAL '1 week' THEN 'consecutive'
            ELSE 'gap'
        END AS weekly_check
    FROM  prev_weekly_sales)
SELECT origin,
    prev_sales_week,
    sales_week
FROM week_checks
WHERE weekly_check = 'gap'
ORDER BY origin, sales_week;
-- Result: Three one-week gaps: Leeds and York had no ticket sales in the week beginning 14 September 2026, and Manchester had none in the week beginning 21 September 2026.
