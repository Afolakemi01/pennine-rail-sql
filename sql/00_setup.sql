-- Pennine Rail: ticket sales dataset (fictional)
-- One row per ticket sold. Travel dates: 1-14 October 2026.
-- Safe to run again: drops and rebuilds the table.

DROP TABLE IF EXISTS tickets;

CREATE TABLE tickets (
    ticket_id       INTEGER       PRIMARY KEY,
    purchase_date   DATE          NOT NULL,   -- date the ticket was bought
    travel_date     DATE          NOT NULL,   -- date of the journey
    origin          TEXT          NOT NULL,   -- departure city
    destination     TEXT          NOT NULL,   -- arrival city
    ticket_type     TEXT          NOT NULL,   -- 'Anytime', 'Off-Peak' or 'Advance'
    travel_class    TEXT          NOT NULL,   -- 'Standard' or 'First'
    passenger_type  TEXT          NOT NULL,   -- 'Adult' or 'Child'
    sales_channel   TEXT          NOT NULL,   -- 'App', 'Website' or 'Station'
    price_gbp       NUMERIC(6,2)  NOT NULL,   -- price paid, in pounds
    ticket_status   TEXT          NOT NULL    -- 'Completed' or 'Refunded'
);

INSERT INTO tickets VALUES
( 1, '2026-09-10', '2026-10-03', 'York'         , 'Manchester'   , 'Advance' , 'First'   , 'Adult', 'Website',  23.00, 'Completed'),
( 2, '2026-09-11', '2026-10-08', 'Leeds'        , 'York'         , 'Advance' , 'First'   , 'Child', 'App'    ,   5.00, 'Completed'),
( 3, '2026-09-11', '2026-10-03', 'Leeds'        , 'Huddersfield' , 'Advance' , 'Standard', 'Adult', 'Website',   4.50, 'Completed'),
( 4, '2026-09-12', '2026-10-02', 'York'         , 'Leeds'        , 'Advance' , 'Standard', 'Adult', 'App'    ,   6.50, 'Completed'),
( 5, '2026-09-12', '2026-10-05', 'Manchester'   , 'Sheffield'    , 'Advance' , 'Standard', 'Adult', 'App'    ,   9.00, 'Completed'),
( 6, '2026-09-13', '2026-10-07', 'York'         , 'Manchester'   , 'Advance' , 'Standard', 'Adult', 'Website',  15.50, 'Completed'),
( 7, '2026-09-13', '2026-10-02', 'Manchester'   , 'Huddersfield' , 'Advance' , 'Standard', 'Adult', 'Website',   6.00, 'Completed'),
( 8, '2026-09-13', '2026-10-10', 'Sheffield'    , 'Leeds'        , 'Advance' , 'Standard', 'Adult', 'Website',   7.50, 'Completed'),
( 9, '2026-09-15', '2026-10-09', 'Huddersfield' , 'Leeds'        , 'Advance' , 'Standard', 'Adult', 'App'    ,   4.50, 'Completed'),
(10, '2026-09-15', '2026-10-08', 'Manchester'   , 'York'         , 'Advance' , 'Standard', 'Adult', 'App'    ,  15.50, 'Completed'),
(11, '2026-09-15', '2026-10-04', 'Manchester'   , 'Leeds'        , 'Advance' , 'First'   , 'Adult', 'Website',  15.00, 'Completed'),
(12, '2026-09-17', '2026-10-01', 'Huddersfield' , 'Leeds'        , 'Advance' , 'First'   , 'Adult', 'App'    ,   6.50, 'Completed'),
(13, '2026-09-18', '2026-10-09', 'Sheffield'    , 'Manchester'   , 'Advance' , 'Standard', 'Adult', 'App'    ,   9.00, 'Completed'),
(14, '2026-09-20', '2026-10-04', 'Huddersfield' , 'Leeds'        , 'Advance' , 'Standard', 'Adult', 'Website',   4.50, 'Refunded'),
(15, '2026-09-23', '2026-10-12', 'Leeds'        , 'Huddersfield' , 'Advance' , 'Standard', 'Child', 'Website',   2.00, 'Completed'),
(16, '2026-09-24', '2026-10-03', 'Leeds'        , 'Huddersfield' , 'Advance' , 'Standard', 'Child', 'App'    ,   2.00, 'Completed'),
(17, '2026-09-24', '2026-10-14', 'Huddersfield' , 'Manchester'   , 'Advance' , 'Standard', 'Adult', 'Website',   6.00, 'Completed'),
(18, '2026-09-25', '2026-10-12', 'Leeds'        , 'York'         , 'Advance' , 'Standard', 'Child', 'App'    ,   3.50, 'Completed'),
(19, '2026-09-26', '2026-10-12', 'Sheffield'    , 'York'         , 'Advance' , 'Standard', 'Adult', 'Website',   9.50, 'Completed'),
(20, '2026-09-26', '2026-10-03', 'York'         , 'Sheffield'    , 'Advance' , 'Standard', 'Adult', 'Website',   9.50, 'Refunded'),
(21, '2026-09-27', '2026-10-10', 'Huddersfield' , 'Manchester'   , 'Advance' , 'Standard', 'Child', 'App'    ,   3.00, 'Completed'),
(22, '2026-09-28', '2026-10-01', 'York'         , 'Sheffield'    , 'Off-Peak', 'Standard', 'Adult', 'App'    ,  14.50, 'Completed'),
(23, '2026-09-28', '2026-10-11', 'Huddersfield' , 'Manchester'   , 'Advance' , 'Standard', 'Adult', 'Website',   6.00, 'Completed'),
(24, '2026-09-29', '2026-10-12', 'York'         , 'Manchester'   , 'Advance' , 'Standard', 'Adult', 'Website',  15.50, 'Completed'),
(25, '2026-09-29', '2026-10-01', 'Leeds'        , 'York'         , 'Anytime' , 'Standard', 'Adult', 'App'    ,  14.50, 'Refunded'),
(26, '2026-09-29', '2026-10-01', 'York'         , 'Manchester'   , 'Anytime' , 'Standard', 'Child', 'Station',  17.00, 'Completed'),
(27, '2026-09-30', '2026-10-03', 'Sheffield'    , 'Manchester'   , 'Off-Peak', 'Standard', 'Adult', 'Station',  13.50, 'Completed'),
(28, '2026-10-02', '2026-10-03', 'Leeds'        , 'Sheffield'    , 'Anytime' , 'Standard', 'Adult', 'App'    ,  17.00, 'Completed'),
(29, '2026-10-02', '2026-10-02', 'Manchester'   , 'Huddersfield' , 'Off-Peak', 'Standard', 'Child', 'Website',   4.50, 'Completed'),
(30, '2026-10-02', '2026-10-05', 'York'         , 'Manchester'   , 'Off-Peak', 'Standard', 'Adult', 'Website',  24.00, 'Completed'),
(31, '2026-10-03', '2026-10-03', 'Leeds'        , 'Huddersfield' , 'Off-Peak', 'Standard', 'Adult', 'Station',   6.50, 'Completed'),
(32, '2026-10-03', '2026-10-03', 'Huddersfield' , 'Leeds'        , 'Anytime' , 'Standard', 'Child', 'Station',   5.00, 'Completed'),
(33, '2026-10-04', '2026-10-04', 'Huddersfield' , 'Manchester'   , 'Anytime' , 'Standard', 'Child', 'App'    ,   7.00, 'Refunded'),
(34, '2026-10-04', '2026-10-04', 'Manchester'   , 'Huddersfield' , 'Off-Peak', 'Standard', 'Adult', 'App'    ,   9.50, 'Completed'),
(35, '2026-10-04', '2026-10-11', 'Leeds'        , 'Huddersfield' , 'Advance' , 'Standard', 'Child', 'Website',   2.00, 'Refunded'),
(36, '2026-10-05', '2026-10-05', 'Manchester'   , 'Leeds'        , 'Off-Peak', 'First'   , 'Adult', 'Station',  23.00, 'Completed'),
(37, '2026-10-05', '2026-10-05', 'Sheffield'    , 'York'         , 'Anytime' , 'First'   , 'Adult', 'Station',  31.50, 'Refunded'),
(38, '2026-10-06', '2026-10-06', 'Manchester'   , 'Leeds'        , 'Anytime' , 'First'   , 'Adult', 'Station',  33.00, 'Completed'),
(39, '2026-10-06', '2026-10-09', 'York'         , 'Leeds'        , 'Anytime' , 'Standard', 'Adult', 'App'    ,  14.50, 'Completed'),
(40, '2026-10-06', '2026-10-07', 'Huddersfield' , 'Manchester'   , 'Off-Peak', 'Standard', 'Adult', 'Website',   9.50, 'Completed'),
(41, '2026-10-07', '2026-10-10', 'York'         , 'Leeds'        , 'Off-Peak', 'Standard', 'Adult', 'Station',  10.00, 'Completed'),
(42, '2026-10-07', '2026-10-09', 'Sheffield'    , 'Manchester'   , 'Off-Peak', 'Standard', 'Adult', 'Website',  13.50, 'Completed'),
(43, '2026-10-07', '2026-10-07', 'Sheffield'    , 'Manchester'   , 'Off-Peak', 'Standard', 'Adult', 'Station',  13.50, 'Completed'),
(44, '2026-10-08', '2026-10-11', 'Leeds'        , 'Manchester'   , 'Anytime' , 'Standard', 'Adult', 'App'    ,  22.00, 'Completed'),
(45, '2026-10-08', '2026-10-10', 'Leeds'        , 'Manchester'   , 'Anytime' , 'Standard', 'Adult', 'App'    ,  22.00, 'Completed'),
(46, '2026-10-08', '2026-10-08', 'Leeds'        , 'Huddersfield' , 'Anytime' , 'Standard', 'Adult', 'Website',   9.50, 'Completed'),
(47, '2026-10-08', '2026-10-08', 'Leeds'        , 'York'         , 'Anytime' , 'Standard', 'Adult', 'App'    ,  14.50, 'Completed'),
(48, '2026-10-09', '2026-10-09', 'Sheffield'    , 'Manchester'   , 'Anytime' , 'Standard', 'Adult', 'Website',  19.50, 'Completed'),
(49, '2026-10-09', '2026-10-10', 'York'         , 'Manchester'   , 'Anytime' , 'Standard', 'Child', 'Website',  17.00, 'Completed'),
(50, '2026-10-09', '2026-10-11', 'York'         , 'Leeds'        , 'Off-Peak', 'First'   , 'Adult', 'Website',  15.00, 'Completed'),
(51, '2026-10-09', '2026-10-09', 'York'         , 'Manchester'   , 'Anytime' , 'First'   , 'Adult', 'Station',  51.00, 'Refunded'),
(52, '2026-10-09', '2026-10-11', 'Sheffield'    , 'York'         , 'Anytime' , 'Standard', 'Adult', 'App'    ,  21.00, 'Completed'),
(53, '2026-10-09', '2026-10-11', 'Leeds'        , 'Manchester'   , 'Off-Peak', 'Standard', 'Adult', 'Station',  15.50, 'Completed'),
(54, '2026-10-09', '2026-10-11', 'Huddersfield' , 'Leeds'        , 'Anytime' , 'First'   , 'Adult', 'Station',  14.00, 'Completed'),
(55, '2026-10-10', '2026-10-12', 'Huddersfield' , 'Leeds'        , 'Anytime' , 'First'   , 'Adult', 'Website',  14.00, 'Refunded'),
(56, '2026-10-10', '2026-10-13', 'York'         , 'Leeds'        , 'Off-Peak', 'First'   , 'Child', 'Station',   7.50, 'Completed'),
(57, '2026-10-10', '2026-10-13', 'York'         , 'Leeds'        , 'Anytime' , 'Standard', 'Adult', 'Website',  14.50, 'Completed'),
(58, '2026-10-11', '2026-10-12', 'Leeds'        , 'York'         , 'Off-Peak', 'Standard', 'Child', 'Station',   5.00, 'Completed'),
(59, '2026-10-11', '2026-10-12', 'York'         , 'Leeds'        , 'Off-Peak', 'Standard', 'Adult', 'App'    ,  10.00, 'Completed'),
(60, '2026-10-13', '2026-10-13', 'Leeds'        , 'Sheffield'    , 'Off-Peak', 'Standard', 'Adult', 'App'    ,  12.00, 'Completed');
