-- Pennine Rail: date, string and set-operation questions
-- Booking lead times, daily reporting, text labels, route comparisons with
-- set operations, and recursive CTEs for the hub network and a date calendar.

-- D1: How far in advance do customers buy each type of ticket?
SELECT ticket_type,
    COUNT(*) AS tickets,
   ROUND(AVG (travel_date - purchase_date), 1) AS avg_days_ahead,
   MAX(travel_date - purchase_date) AS max_days_ahead
FROM tickets
GROUP BY ticket_type
ORDER BY avg_days_ahead DESC;
-- Result: Advance tickets are bought furthest ahead (18.1 days on average, up to 27);
--         Anytime tickets are bought latest (1.2 days on average).

-- D2: Give a day-by-day view of the fortnight, with the weekday name next to each date so I can spot weekend patterns.
SELECT travel_date,
       TO_CHAR(travel_date, 'FMDay') AS weekday,
       COUNT(*) AS tickets,
       SUM(price_gbp) AS total_value_gbp
FROM tickets
GROUP BY travel_date
ORDER BY travel_date;
-- Result: 14 days, every day had at least one ticket. Busiest day: 2026-10-03 (Saturday, 8 tickets);
--         quietest days: 2026-10-06 (Tuesday) and 2026-10-14 (Wednesday), 1 ticket each.

-- D3: Print one line per station, for example Bradford (BDI), West Yorkshire. If a station’s region isn’t on record, show Region unknown instead of leaving the line blank.
SELECT s.station_code,
    CONCAT(s.station_name,
    ' (', s.station_code, '), ',
    COALESCE(r.region_name, 'Region unknown')) AS directory_line
FROM stations s
LEFT JOIN regions r
ON s.region_code = r.region_code
ORDER BY s.station_name;
-- Result: 7 lines. Wakefield (WKF) shows Region unknown: its region code WYK has no match in regions.

-- D4: For each route sold, did anyone also buy the return direction?
SELECT origin,
    destination
FROM tickets

EXCEPT

SELECT destination,
    origin
FROM tickets

ORDER BY origin, destination;
-- Result: 0 one-way routes. All 16 routes sold were also sold in the reverse direction
--         (checked: 16 distinct routes, 16 in routes INTERSECT reversed routes).

-- D5: Show the network as a map: each top-level hub, with the stations that feed into it listed under it, and how many steps each station is from the top.
WITH RECURSIVE base AS (
    SELECT station_code,
        station_name,
        hub_station_code,
        0 AS level,
        station_name AS network_path
    FROM stations
    WHERE hub_station_code IS NULL

UNION ALL

SELECT st.station_code,
    st.station_name,
    st.hub_station_code,
    b.level + 1,
    CONCAT(b.network_path, ' > ', st.station_name) AS network_path
FROM stations st
JOIN base b
ON st.hub_station_code = b.station_code
)

SELECT station_code,
    station_name,
    level,
    network_path
FROM base
ORDER BY network_path;
-- Result: The network contains 7 stations across 2 top-level hubs (Leeds and Manchester), with a highest level of 1.

-- Day 6: Show me every day of the fortnight with the number of tickets departing from York, including the days with none
WITH RECURSIVE calendar AS (
    SELECT DATE '2026-10-01' AS day
    UNION ALL
    SELECT c.day + 1
    FROM calendar c
    WHERE c.day < DATE '2026-10-14'
),
york_travel AS (
    SELECT travel_date,
        origin
    FROM tickets
    WHERE origin = 'York'
)

SELECT c.day AS travel_date,
    TO_CHAR(c.day, 'FMDay') AS weekday,
    COUNT(yt.origin) AS york_departures
FROM calendar c
LEFT JOIN york_travel yt
    ON c.day = yt.travel_date
GROUP BY c.day
ORDER BY c.day;
-- Result: 16 York departures over 1–14 October 2026; 4 days had none (4, 6, 8 and 14 October).
