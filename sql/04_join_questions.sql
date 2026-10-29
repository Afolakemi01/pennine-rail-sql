-- J1. How many tickets has each station sold as a departure station?
SELECT s.station_name, COUNT(t.ticket_id) AS tickets_sold
FROM stations AS s
LEFT JOIN tickets AS t
ON s.station_name = t.origin
GROUP BY s.station_name
ORDER BY tickets_sold DESC, station_name;
-- Result: Leeds and York lead with 16 departures each; Bradford and Wakefield have none. The counts total 60, matching the tickets table, so every ticket's origin matched a station.

-- J2. How many Advance tickets departed from each station?
SELECT s.station_name, COUNT(t.ticket_id) AS advance_tickets
FROM stations AS s
LEFT JOIN tickets AS t
ON s.station_name = t.origin
AND t.ticket_type = 'Advance'
GROUP BY s.station_name
ORDER BY advance_tickets DESC, station_name;
-- Result: Huddersfield and Leeds lead with 6 Advance departures each, followed by York (5), Manchester (4) and Sheffield (3); Bradford and Wakefield have none.

-- J3. Do any stations point to a region that doesn’t exist in the regions table?
SELECT s.station_code, s.station_name, s.region_code
FROM stations AS s
LEFT JOIN regions AS r
ON s.region_code = r.region_code
WHERE r.region_code IS NULL
ORDER BY s.station_code;
-- Result: One orphan: Wakefield (WKF) has region_code 'WYK', which does not exist in regions; it is most likely a typo for 'WY' (West Yorkshire) and should be corrected at source.

-- J4. Do any tickets have a destination that isn’t a known station?
SELECT t.ticket_id, t.destination
FROM tickets AS t
LEFT JOIN stations AS s
ON t.destination = s.station_name
WHERE s.station_name IS NULL
ORDER BY t.ticket_id;
-- Result: No orphans: every ticket destination matches a station in the stations table.
