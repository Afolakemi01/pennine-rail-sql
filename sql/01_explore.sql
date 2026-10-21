-- E1. What do the first few tickets look like?
-- Requirements:
--   1. Show every column.
--   2. Order by ticket_id, lowest first.
--   3. Return only the first 5 tickets.
SELECT *
FROM tickets
ORDER BY ticket_id
LIMIT 5;
-- Result: The first 5 tickets are all Advance, bought in September for October travel, so the earliest rows are not a fair sample of the table.

-- E2. Which ticket types appear in the data?
-- Requirements:
--   1. Show ticket_type.
--   2. List each ticket type once.
--   3. Sort alphabetically.
SELECT DISTINCT ticket_type
FROM tickets
ORDER BY ticket_type;
-- Result: Three ticket types appear (Advance, Anytime, Off-Peak), matching the documented values with no spelling variants. The first 5 rows showed only Advance, so sampling the top rows would have missed two of them.
