-- Pennine Rail: ticket sales dataset (fictional)
-- One row per ticket sold. Travel dates: 1-14 October 2026.
-- Safe to run again: drops and rebuilds the table.

DROP TABLE IF EXISTS tickets;

CREATE TABLE tickets (
    ticket_id        INTEGER       PRIMARY KEY,
    purchase_date    DATE          NOT NULL,   -- date the ticket was bought
    travel_date      DATE          NOT NULL,   -- date of the journey
    origin           TEXT          NOT NULL,   -- departure city
    destination      TEXT          NOT NULL,   -- arrival city
    ticket_type      TEXT          NOT NULL,   -- 'Anytime', 'Off-Peak' or 'Advance'
    travel_class     TEXT          NOT NULL,   -- 'Standard' or 'First'
    passenger_type   TEXT          NOT NULL,   -- 'Adult' or 'Child'
    sales_channel    TEXT          NOT NULL,   -- 'App', 'Website' or 'Station'
    price_gbp        NUMERIC(6,2)  NOT NULL,   -- price paid, in pounds
    ticket_status    TEXT          NOT NULL,   -- 'Completed' or 'Refunded'
    customer_rating  SMALLINT                  -- post-journey survey score, 1 (poor) to 5 (excellent);
                                               -- NULL = no survey response
);

INSERT INTO tickets VALUES
( 1, '2026-09-10', '2026-10-03', 'York'         , 'Manchester'   , 'Advance' , 'First'   , 'Adult', 'Website',  23.00, 'Completed', NULL),
( 2, '2026-09-11', '2026-10-08', 'Leeds'        , 'York'         , 'Advance' , 'First'   , 'Child', 'App'    ,   5.00, 'Completed',    4),
( 3, '2026-09-11', '2026-10-03', 'Leeds'        , 'Huddersfield' , 'Advance' , 'Standard', 'Adult', 'Website',   4.50, 'Completed',    2),
( 4, '2026-09-12', '2026-10-02', 'York'         , 'Leeds'        , 'Advance' , 'Standard', 'Adult', 'App'    ,   6.50, 'Completed', NULL),
( 5, '2026-09-12', '2026-10-05', 'Manchester'   , 'Sheffield'    , 'Advance' , 'Standard', 'Adult', 'App'    ,   9.00, 'Completed',    4),
( 6, '2026-09-13', '2026-10-07', 'York'         , 'Manchester'   , 'Advance' , 'Standard', 'Adult', 'Website',  15.50, 'Completed',    4),
( 7, '2026-09-13', '2026-10-02', 'Manchester'   , 'Huddersfield' , 'Advance' , 'Standard', 'Adult', 'Website',   6.00, 'Completed',    5),
( 8, '2026-09-13', '2026-10-10', 'Sheffield'    , 'Leeds'        , 'Advance' , 'Standard', 'Adult', 'Website',   7.50, 'Completed',    4),
( 9, '2026-09-15', '2026-10-09', 'Huddersfield' , 'Leeds'        , 'Advance' , 'Standard', 'Adult', 'App'    ,   4.50, 'Completed', NULL),
(10, '2026-09-15', '2026-10-08', 'Manchester'   , 'York'         , 'Advance' , 'Standard', 'Adult', 'App'    ,  15.50, 'Completed',    2),
(11, '2026-09-15', '2026-10-04', 'Manchester'   , 'Leeds'        , 'Advance' , 'First'   , 'Adult', 'Website',  15.00, 'Completed',    4),
(12, '2026-09-17', '2026-10-01', 'Huddersfield' , 'Leeds'        , 'Advance' , 'First'   , 'Adult', 'App'    ,   6.50, 'Completed',    4),
(13, '2026-09-18', '2026-10-09', 'Sheffield'    , 'Manchester'   , 'Advance' , 'Standard', 'Adult', 'App'    ,   9.00, 'Completed',    0),
(14, '2026-09-20', '2026-10-04', 'Huddersfield' , 'Leeds'        , 'Advance' , 'Standard', 'Adult', 'Website',   4.50, 'Refunded' , NULL),
(15, '2026-09-23', '2026-10-12', 'Leeds'        , 'Huddersfield' , 'Advance' , 'Standard', 'Child', 'Website',   2.00, 'Completed',    5),
(16, '2026-09-24', '2026-10-03', 'Leeds'        , 'Huddersfield' , 'Advance' , 'Standard', 'Child', 'App'    ,   2.00, 'Completed',    5),
(17, '2026-09-24', '2026-10-14', 'Huddersfield' , 'Manchester'   , 'Advance' , 'Standard', 'Adult', 'Website',   6.00, 'Completed',    4),
(18, '2026-09-25', '2026-10-12', 'Leeds'        , 'York'         , 'Advance' , 'Standard', 'Child', 'App'    ,   3.50, 'Completed', NULL),
(19, '2026-09-26', '2026-10-12', 'Sheffield'    , 'York'         , 'Advance' , 'Standard', 'Adult', 'Website',   9.50, 'Completed',    4),
(20, '2026-09-26', '2026-10-03', 'York'         , 'Sheffield'    , 'Advance' , 'Standard', 'Adult', 'Website',   9.50, 'Refunded' , NULL),
(21, '2026-09-27', '2026-10-10', 'Huddersfield' , 'Manchester'   , 'Advance' , 'Standard', 'Child', 'App'    ,   3.00, 'Completed',    4),
(22, '2026-09-28', '2026-10-01', 'York'         , 'Sheffield'    , 'Off-Peak', 'Standard', 'Adult', 'App'    ,  14.50, 'Completed',    4),
(23, '2026-09-28', '2026-10-11', 'Huddersfield' , 'Manchester'   , 'Advance' , 'Standard', 'Adult', 'Website',   6.00, 'Completed',    1),
(24, '2026-09-29', '2026-10-12', 'York'         , 'Manchester'   , 'Advance' , 'Standard', 'Adult', 'Website',  15.50, 'Completed',    3),
(25, '2026-09-29', '2026-10-01', 'Leeds'        , 'York'         , 'Anytime' , 'Standard', 'Adult', 'App'    ,  14.50, 'Refunded' , NULL),
(26, '2026-09-29', '2026-10-01', 'York'         , 'Manchester'   , 'Anytime' , 'Standard', 'Child', 'Station',  17.00, 'Completed',    3),
(27, '2026-09-30', '2026-10-03', 'Sheffield'    , 'Manchester'   , 'Off-Peak', 'Standard', 'Adult', 'Station',  13.50, 'Completed',    4),
(28, '2026-10-02', '2026-10-03', 'Leeds'        , 'Sheffield'    , 'Anytime' , 'Standard', 'Adult', 'App'    ,  17.00, 'Completed', NULL),
(29, '2026-10-02', '2026-10-02', 'Manchester'   , 'Huddersfield' , 'Off-Peak', 'Standard', 'Child', 'Website',   4.50, 'Completed',    5),
(30, '2026-10-02', '2026-10-05', 'York'         , 'Manchester'   , 'Off-Peak', 'Standard', 'Adult', 'Website',  24.00, 'Completed',    4),
(31, '2026-10-03', '2026-10-03', 'Leeds'        , 'Huddersfield' , 'Off-Peak', 'Standard', 'Adult', 'Station',   6.50, 'Completed',    3),
(32, '2026-10-03', '2026-10-03', 'Huddersfield' , 'Leeds'        , 'Anytime' , 'Standard', 'Child', 'Station',   5.00, 'Completed',    5),
(33, '2026-10-04', '2026-10-04', 'Huddersfield' , 'Manchester'   , 'Anytime' , 'Standard', 'Child', 'App'    ,   7.00, 'Refunded' , NULL),
(34, '2026-10-04', '2026-10-04', 'Manchester'   , 'Huddersfield' , 'Off-Peak', 'Standard', 'Adult', 'App'    ,   9.50, 'Completed',    4),
(35, '2026-10-04', '2026-10-11', 'Leeds'        , 'Huddersfield' , 'Advance' , 'Standard', 'Child', 'Website',   2.00, 'Refunded' , NULL),
(36, '2026-10-05', '2026-10-05', 'Manchester'   , 'Leeds'        , 'Off-Peak', 'First'   , 'Adult', 'Station',  23.00, 'Completed', NULL),
(37, '2026-10-05', '2026-10-05', 'Sheffield'    , 'York'         , 'Anytime' , 'First'   , 'Adult', 'Station',  31.50, 'Refunded' , NULL),
(38, '2026-10-06', '2026-10-06', 'Manchester'   , 'Leeds'        , 'Anytime' , 'First'   , 'Adult', 'Station',  33.00, 'Completed', NULL),
(39, '2026-10-06', '2026-10-09', 'York'         , 'Leeds'        , 'Anytime' , 'Standard', 'Adult', 'App'    ,  14.50, 'Completed', NULL),
(40, '2026-10-06', '2026-10-07', 'Huddersfield' , 'Manchester'   , 'Off-Peak', 'Standard', 'Adult', 'Website',   9.50, 'Completed', NULL),
(41, '2026-10-07', '2026-10-10', 'York'         , 'Leeds'        , 'Off-Peak', 'Standard', 'Adult', 'Station',  10.00, 'Completed',    5),
(42, '2026-10-07', '2026-10-09', 'Sheffield'    , 'Manchester'   , 'Off-Peak', 'Standard', 'Adult', 'Website',  13.50, 'Completed', NULL),
(43, '2026-10-07', '2026-10-07', 'Sheffield'    , 'Manchester'   , 'Off-Peak', 'Standard', 'Adult', 'Station',  13.50, 'Completed',    4),
(44, '2026-10-08', '2026-10-11', 'Leeds'        , 'Manchester'   , 'Anytime' , 'Standard', 'Adult', 'App'    ,  22.00, 'Completed',    3),
(45, '2026-10-08', '2026-10-10', 'Leeds'        , 'Manchester'   , 'Anytime' , 'Standard', 'Adult', 'App'    ,  22.00, 'Completed',    4),
(46, '2026-10-08', '2026-10-08', 'Leeds'        , 'Huddersfield' , 'Anytime' , 'Standard', 'Adult', 'Website',   9.50, 'Completed',    4),
(47, '2026-10-08', '2026-10-08', 'Leeds'        , 'York'         , 'Anytime' , 'Standard', 'Adult', 'App'    ,  14.50, 'Completed',    5),
(48, '2026-10-09', '2026-10-09', 'Sheffield'    , 'Manchester'   , 'Anytime' , 'Standard', 'Adult', 'Website',  19.50, 'Completed',    4),
(49, '2026-10-09', '2026-10-10', 'York'         , 'Manchester'   , 'Anytime' , 'Standard', 'Child', 'Website',  17.00, 'Completed',    3),
(50, '2026-10-09', '2026-10-11', 'York'         , 'Leeds'        , 'Off-Peak', 'First'   , 'Adult', 'Website',  15.00, 'Completed',    4),
(51, '2026-10-09', '2026-10-09', 'York'         , 'Manchester'   , 'Anytime' , 'First'   , 'Adult', 'Station',  51.00, 'Refunded' , NULL),
(52, '2026-10-09', '2026-10-11', 'Sheffield'    , 'York'         , 'Anytime' , 'Standard', 'Adult', 'App'    ,  21.00, 'Completed',    5),
(53, '2026-10-09', '2026-10-11', 'Leeds'        , 'Manchester'   , 'Off-Peak', 'Standard', 'Adult', 'Station',  15.50, 'Completed',    3),
(54, '2026-10-09', '2026-10-11', 'Huddersfield' , 'Leeds'        , 'Anytime' , 'First'   , 'Adult', 'Station',  14.00, 'Completed',    1),
(55, '2026-10-10', '2026-10-12', 'Huddersfield' , 'Leeds'        , 'Anytime' , 'First'   , 'Adult', 'Website',  14.00, 'Refunded' , NULL),
(56, '2026-10-10', '2026-10-13', 'York'         , 'Leeds'        , 'Off-Peak', 'First'   , 'Child', 'Station',   7.50, 'Completed',    4),
(57, '2026-10-10', '2026-10-13', 'York'         , 'Leeds'        , 'Anytime' , 'Standard', 'Adult', 'Website',  14.50, 'Completed',    4),
(58, '2026-10-11', '2026-10-12', 'Leeds'        , 'York'         , 'Off-Peak', 'Standard', 'Child', 'Station',   5.00, 'Completed',    5),
(59, '2026-10-11', '2026-10-12', 'York'         , 'Leeds'        , 'Off-Peak', 'Standard', 'Adult', 'App'    ,  10.00, 'Completed',    4),
(60, '2026-10-13', '2026-10-13', 'Leeds'        , 'Sheffield'    , 'Off-Peak', 'Standard', 'Adult', 'App'    ,  12.00, 'Completed',    5);

-- Reference data: regions and stations.
-- Loaded as received from the source system, without foreign keys;
-- referential integrity is checked in 04_join_questions.sql.
DROP TABLE IF EXISTS stations;
DROP TABLE IF EXISTS regions;

CREATE TABLE regions (
    region_code      text PRIMARY KEY,
    region_name      text NOT NULL,
    regional_manager text NOT NULL
);

INSERT INTO regions (region_code, region_name, regional_manager) VALUES
    ('GM', 'Greater Manchester', 'Priya Shah'),
    ('WY', 'West Yorkshire',     'Tom Ellis'),
    ('SY', 'South Yorkshire',    'Grace Okafor'),
    ('NY', 'North Yorkshire',    'Daniel Hirst'),
    ('HB', 'Humber',             'Sarah Lund');

CREATE TABLE stations (
    station_code     text PRIMARY KEY,
    station_name     text NOT NULL UNIQUE,
    region_code      text NOT NULL,
    hub_station_code text
);

INSERT INTO stations (station_code, station_name, region_code, hub_station_code) VALUES
    ('MAN', 'Manchester',   'GM',  NULL),
    ('LDS', 'Leeds',        'WY',  NULL),
    ('HUD', 'Huddersfield', 'WY',  'LDS'),
    ('BDI', 'Bradford',     'WY',  'LDS'),
    ('SHF', 'Sheffield',    'SY',  'MAN'),
    ('YRK', 'York',         'NY',  'LDS'),
    ('WKF', 'Wakefield',    'WYK', 'LDS');
