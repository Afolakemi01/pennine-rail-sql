# Pennine Rail — SQL Analysis
SQL analysis of ticket sales data for Pennine Rail, a fictional train operator in the north of England, using PostgreSQL to answer commercial questions about sales, prices, routes and customer satisfaction.

## Dataset
One table, `tickets`, at the grain of one row per ticket sold. It covers 60 tickets for journeys between 1 and 14 October 2026. `customer_rating` holds a post-journey survey score from 1 to 5 and is NULL where no survey response was received.

Two reference tables support multi-table analysis:

- `regions`: one row per operating region (code, name, regional manager).
- `stations`: one row per station, with its region and its hub station. Tickets link to stations by station name.

The reference tables are loaded as received from the source system. Foreign keys and CHECK constraints are added afterwards by `08_constraints.sql` (see Data integrity).

## Repository structure

```
pennine-rail-sql/
├── README.md
└── sql/
    ├── 00_setup.sql          # creates and loads the tickets, stations and regions tables
    ├── 01_explore.sql            # data profiling checks
    ├── 02_business_questions.sql # commercial questions and answers
    ├── 03_aggregation_questions.sql # grouped totals, rating bands and averages
    ├── 04_join_questions.sql     # multi-table analysis and referential integrity checks
    ├── 05_subquery_questions.sql # subqueries, CTEs, NULL-safe anti-joins and fan-out checks
    ├── 06_dates_strings_sets.sql # date and string reporting, set operations and recursive CTEs
    ├── 07_window_functions.sql  # window-function analysis: revenue share, running totals, moving averages, ranking, latest record per station, month-on-month change and sales-gap detection
    ├── 08_constraints.sql      # orphan checks, data corrections, foreign keys and CHECK constraints
    └── 09_normalisation.sql     # functional dependencies, normal-form review and fare-dependency check
```

## How to run

Requires PostgreSQL. From the repository root:

```bash
createdb pennine_rail
psql -d pennine_rail -f sql/00_setup.sql
psql -d pennine_rail -P pager=off -f sql/08_constraints.sql
psql -d pennine_rail -P pager=off -f sql/01_explore.sql
psql -d pennine_rail -P pager=off -f sql/02_business_questions.sql
psql -d pennine_rail -P pager=off -f sql/03_aggregation_questions.sql
psql -d pennine_rail -P pager=off -f sql/04_join_questions.sql
psql -d pennine_rail -P pager=off -f sql/05_subquery_questions.sql
psql -d pennine_rail -P pager=off -f sql/06_dates_strings_sets.sql
psql -d pennine_rail -P pager=off -f sql/07_window_functions.sql
psql -d pennine_rail -P pager=off -f sql/09_normalisation.sql
```

`00_setup.sql` drops and rebuilds the tables from the raw load, which removes all constraints and restores two uncorrected rows. Always run `08_constraints.sql` immediately after it.

## Data integrity

`sql/08_constraints.sql` adds the relationships and business rules the original load did not enforce. Every rule was checked against the existing data before it was added.

**Primary keys** (created in `00_setup.sql`): `tickets.ticket_id`, `stations.station_code`, `regions.region_code`. `stations.station_name` is also unique.

**Foreign keys**

| Constraint | Rule | ON DELETE | Reason |
|---|---|---|---|
| `fk_tickets_origin` | `tickets.origin` → `stations.station_name` | RESTRICT | Tickets are sales records; a station with ticket history cannot be removed |
| `fk_tickets_destination` | `tickets.destination` → `stations.station_name` | RESTRICT | As above |
| `fk_stations_region_code` | `stations.region_code` → `regions.region_code` | RESTRICT | Deleting a region must not silently remove its stations |
| `fk_stations_hub_code` | `stations.hub_station_code` → `stations.station_code` | SET NULL | NULL already means "no hub"; if a hub is removed, its stations become hub-less rather than invalid |

**CHECK constraints**

| Constraint | Rule | Reason |
|---|---|---|
| `chk_tickets_price` | `price_gbp >= 0` | Free tickets (e.g. staff travel) are valid; negative prices are not |
| `chk_tickets_customer_rating` | `customer_rating BETWEEN 1 AND 5` | Matches the 1–5 survey scale; NULL (no response) is still allowed |
| `chk_tickets_purchase_before_travel` | `travel_date >= purchase_date` | Same-day purchases are valid; travel before purchase is not |
| `chk_tickets_status` | `ticket_status` is `Completed` or `Refunded` | The only statuses in use; a new status requires a deliberate change to this rule |

**Data corrections**

Two rows broke the new rules and were corrected before the constraints were added:

- **Wakefield (`WKF`)** had region code `WYK`, which does not exist in `regions`. Corrected to `WY` (West Yorkshire): every other region code has two letters, and Wakefield's hub, Leeds, is also in West Yorkshire.
- **Ticket 13** had a customer rating of 0, outside the 1–5 scale. Set to NULL (no valid response).

Correcting the rating raised the network average rating from 3.76 to 3.85 and changed which stations fall below it: York replaced Sheffield. The findings below reflect the corrected data.

## Data model and normalisation

`sql/09_normalisation.sql` documents the functional dependencies behind the schema and reviews it against the first three normal forms.

**Functional dependencies**
- `tickets`: `ticket_id -> purchase_date, travel_date, origin, destination, ticket_type, travel_class, passenger_type, sales_channel, price_gbp, ticket_status, customer_rating`
- `stations`: `station_code -> station_name, region_code, hub_station_code` and `station_name -> station_code, region_code, hub_station_code` (two candidate keys; `station_code` is the primary key and `station_name` is `UNIQUE`)
- `regions`: `region_code -> region_name, regional_manager`

**Verdict:** all three tables are in 3NF. Every column holds a single value (1NF), and every determinant is a candidate key, so no column depends on part of a key (2NF) or on a non-key column (3NF).

**Design decisions**
- **Price is stored on each ticket.** A check for `(origin, destination, ticket_type, travel_class, passenger_type) -> price_gbp` found no conflicting prices, but only 11 of 47 combinations occur more than once. Fares change over time, so `price_gbp` records the price paid at purchase. Moving it to a fares table would rewrite historical sales whenever a fare changed.
- **Region is not copied onto tickets.** Regional reporting joins `tickets -> stations -> regions`. Storing the region on each ticket would save one join but create an update anomaly if a station changed region.
- **Fixed value sets use CHECK constraints, not lookup tables.** Ticket type, class, passenger type, channel and status have no attributes of their own, so a lookup table would add joins without removing any dependency.
- **Known trade-off:** `tickets` references stations by name, a descriptive attribute that can change. Renaming a station is blocked by the foreign keys (default `ON UPDATE NO ACTION`) while tickets still reference the old name. Migrating `tickets` to `station_code`, with a view that keeps the current column names for existing queries, is a planned improvement.

## Findings

**Data profiling**
- The three ticket types in the data (Advance, Anytime, Off-Peak) match the documented values, with no spelling variants.
- The lowest price is £2.00 and there are no zero or negative prices.
- Ticket IDs follow purchase order, so the first rows are all Advance tickets and are not a representative sample.

**Commercial questions**
- Advance tickets are sold only through the App and the Website; none are sold at stations.
- First class tickets were sold on 6 routes, all starting or ending in Leeds or York.
- The two most expensive refunded tickets bought at a station or online (£51.00 and £31.50) were both bought at a station.
- When ranking the top 2 Adult Standard tickets, 2nd and 3rd place are tied at £22.00, so both are reported rather than one being dropped arbitrarily.

**Aggregation analysis**
- Website generated the most revenue from completed tickets (£237.50 from 20 tickets), £16.00 ahead of App (£221.50, also 20 tickets); Station was lowest (£163.50 from 12 tickets).
- 11 of the 16 routes sold at least 3 tickets. York → Leeds and York → Manchester were the busiest (7 tickets each), followed by Leeds ↔ Huddersfield (6 each way).
- Of the 41 valid survey ratings, 31 (76%) were Satisfied (4–5). 19 tickets had no valid response, including all 8 refunded tickets.
- Standard class had a higher average customer rating of 3.91, based on 35 valid survey responses, compared with First class's average of 3.50, based on 6 valid responses. However, this comparison should be treated with caution because First class had a much lower response rate (50%) than Standard class (75%). The smaller number of First class responses means its average may be less representative of all First class passengers' experiences.

**Joins**
- Departures by station: Leeds and York lead with 16 departures each; Bradford and Wakefield have none. Counts total 60, reconciling with the tickets table.
- Advance tickets: Huddersfield and Leeds lead with 6 Advance departures each.
- Data quality: the integrity check found one orphan in the raw load: Wakefield's region code `WYK` had no match in `regions`. It was corrected to `WY` (see Data integrity), and the check now returns no orphans. All ticket origins and destinations match a known station.
- Network structure: Leeds is the hub for four stations; Sheffield's hub is Manchester.
- By region: North Yorkshire has the highest ticket value (£265.00); West Yorkshire has the most departures (27). Humber has no stations.

**Subqueries and CTEs**
- Price: 29 of the 60 tickets sold for more than the network average of £12.61. The most expensive was £51.00 (York → Manchester).
- Customer experience: departures from Huddersfield, Leeds and Manchester received at least one 1–2 star rating.
- Ratings by station: Huddersfield (3.17 from 6 ratings) and York (3.82 from 11) are rated below the network average of 3.85.
- Hub coverage: five stations (Bradford, Huddersfield, Sheffield, Wakefield, York) are not a hub for any station. A `NOT IN` version of this query returns no rows, because `hub_station_code` contains NULL; `NOT EXISTS` is used instead.
- Departures per station: the 5 stations with departures average 12.0 each. Across all 7 stations the average would be 8.6, because Bradford and Wakefield have none, so the figure depends on which stations are included.
- Departures and arrivals: joining tickets to stations twice multiplies the rows (Huddersfield's 11 departures × 9 arrivals = 99). Counting each side before joining gives the correct figures, which reconcile to 60 departures and 60 arrivals. Manchester receives the most arrivals (20).

**Dates, strings and set operations**
- Booking lead time: Advance tickets are bought 18.1 days ahead on average (up to 27 days); Off-Peak and Anytime tickets are bought within 3 days.
- Daily demand: every day from 1 to 14 October had at least one ticket. The busiest day was Saturday 3 October (8 tickets).
- Station directory: all 7 stations are listed with their region. A station with an unmatched region code is labelled "Region unknown" rather than dropped from the list.
- Route balance: all 16 routes sold were also sold in the reverse direction, so there are no one-way routes. This was confirmed with an INTERSECT count, because an empty result alone does not prove the query is correct.
- Network depth: Leeds and Manchester are the only top-level hubs, and every other station is exactly one level below its hub.
- York gaps: York had 16 departures, and no departures on 4 of the 14 days (4, 6, 8 and 14 October). These gaps were found by joining a generated calendar to the tickets.

**Window functions**
- Channel mix by ticket type: Advance revenue comes mainly from the Website (63.1%), Anytime from the App (46.2%) and Off-Peak from station sales (45.7%).
- Station takings: completed station sales built up to £163.50 across 12 tickets between 29 September and 11 October 2026.
- Daily trend: daily completed revenue ranged from £6.00 to £93.50; the 3-day moving average peaked at £71.33 on 11 October. Travel dates after 13 October are under-represented because the data covers purchases up to that date.
- Top price points: Manchester has the highest top price (£33.00); Leeds has two tickets tied at £22.00, so price points are ranked with `DENSE_RANK` to keep its second price point (£17.00).
- Latest sale per station: four stations' latest tickets were completed; Huddersfield's latest (#55) was refunded. Leeds made the most recent sale, on 13 October 2026.
- Month-on-month: completed revenue rose from £220.00 (September purchases) to £402.50 (October purchases), an increase of £182.50.
- Sales gaps: three one-week gaps were found: Leeds and York (week beginning 14 September) and Manchester (week beginning 21 September). Gaps before a station's first sale or after its last are not detectable with this method.
