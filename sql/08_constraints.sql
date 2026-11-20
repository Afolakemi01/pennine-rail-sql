-- C1: Which ticket origins have no matching station, and how many tickets use each?
SELECT t.origin,
       COUNT(*) AS ticket_count
FROM tickets t
LEFT JOIN stations s
  ON t.origin = s.station_name
WHERE s.station_name IS NULL
GROUP BY t.origin
ORDER BY ticket_count DESC;
-- There are 0 origins with no matching station.

-- C2: Which ticket destinations have no matching station, and how many tickets use each?
SELECT t.destination,
       COUNT(*) AS ticket_count
FROM tickets t
LEFT JOIN stations s
  ON t.destination = s.station_name
WHERE s.station_name IS NULL
GROUP BY t.destination
ORDER BY ticket_count DESC;
-- There are 0 destinations with no matching station.

-- C3: Which stations.region_code have no matching regions.region_code, and how many stations use it?
SELECT s.region_code,
    COUNT(*) AS station_count
FROM stations s
LEFT JOIN regions r
    ON s.region_code = r.region_code
WHERE r.region_code IS NULL
GROUP BY s.region_code
ORDER BY s.region_code;
-- Result: WYK appeared once in stations but it has no parent in regions

-- Fix: Wakefield's region_code 'WYK' is a typo for 'WY' (West Yorkshire)
-- 1. Preview: which rows will change?
SELECT station_code, station_name, region_code
FROM stations
WHERE station_code = 'WKF' AND region_code = 'WYK';

-- 2. Correct the typo
UPDATE stations
SET region_code = 'WY'
WHERE station_code = 'WKF' AND region_code = 'WYK';

-- C4: Which stations name a hub that does not exist, and how many stations use each?
SELECT s.hub_station_code,
       COUNT(*) AS station_count
FROM stations s
LEFT JOIN stations h
  ON s.hub_station_code = h.station_code
WHERE s.hub_station_code IS NOT NULL
  AND h.station_code IS NULL
GROUP BY s.hub_station_code
ORDER BY s.hub_station_code;
-- Result: 0 rows. Every named hub is a real station.

-- FK1: every ticket origin must be a real station
ALTER TABLE tickets
  ADD CONSTRAINT fk_tickets_origin
  FOREIGN KEY (origin)
  REFERENCES stations (station_name)
  ON DELETE RESTRICT;

-- FK2: every ticket destination must be a real station
ALTER TABLE tickets
    ADD CONSTRAINT fk_tickets_destination
    FOREIGN KEY (destination)
    REFERENCES stations (station_name)
    ON DELETE RESTRICT;

-- FK3: every station region code must be a real region code
ALTER TABLE stations
    ADD CONSTRAINT fk_stations_region_code
    FOREIGN KEY (region_code)
    REFERENCES regions (region_code)
    ON DELETE RESTRICT;

-- FK4: every station hub station code must be a real station code
ALTER TABLE stations
    ADD CONSTRAINT fk_stations_hub_code
    FOREIGN KEY (hub_station_code)
    REFERENCES stations (station_code)
    ON DELETE SET NULL;

-- P1: What ranges and values exist in the columns that need CHECK rules?
SELECT MIN(price_gbp)                                AS min_price,
       MAX(price_gbp)                                AS max_price,
       MIN(customer_rating)                          AS min_rating,
       MAX(customer_rating)                          AS max_rating,
       COUNT(*) FILTER (WHERE travel_date < purchase_date) AS travel_before_purchase
FROM tickets;

-- P2: Which ticket_status values exist?
SELECT ticket_status, COUNT(*) AS ticket_count
FROM tickets
GROUP BY ticket_status
ORDER BY ticket_status;

-- P3: Which tickets have a rating of 0?
SELECT ticket_id, ticket_status, customer_rating
FROM tickets
WHERE customer_rating = 0;

-- updating 0 rating to null
UPDATE tickets
SET customer_rating = NULL
WHERE ticket_id = 13
  AND customer_rating = 0;

-- CHK1: a ticket price can be free but never negative
ALTER TABLE tickets
  ADD CONSTRAINT chk_tickets_price
  CHECK (price_gbp >= 0);

-- CHK2: a customer_rating must be between 1 and 5
ALTER TABLE tickets
  ADD CONSTRAINT chk_tickets_customer_rating
  CHECK (customer_rating BETWEEN 1 AND 5);

-- CHK3: travel_date can’t be before purchase_date
ALTER TABLE tickets
  ADD CONSTRAINT chk_tickets_purchase_before_travel
  CHECK (travel_date >= purchase_date);

-- CHK4: ticket_status must be 'Completed' or 'Refunded'
ALTER TABLE tickets
  ADD CONSTRAINT chk_tickets_status
  CHECK (ticket_status = 'Completed'
      OR  ticket_status = 'Refunded');
