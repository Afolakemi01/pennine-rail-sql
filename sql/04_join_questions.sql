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
