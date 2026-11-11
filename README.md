# Pennine Rail — SQL Analysis
SQL analysis of ticket sales data for Pennine Rail, a fictional train operator in the north of England, using PostgreSQL to answer commercial questions about sales, prices, routes and customer satisfaction.

## Dataset
One table, `tickets`, at the grain of one row per ticket sold. It covers 60 tickets for journeys between 1 and 14 October 2026. `customer_rating` holds a post-journey survey score from 1 to 5 and is NULL where no survey response was received.

Two reference tables support multi-table analysis:

- `regions`: one row per operating region (code, name, regional manager).
- `stations`: one row per station, with its region and its hub station. Tickets link to stations by station name.

The reference tables are loaded as received from the source system, without foreign keys, so referential integrity is verified by query (see `04_join_questions.sql`).

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
    └── 06_dates_strings_sets.sql # date and string reporting, set operations and recursive CTEs
```

## How to run

Requires PostgreSQL. From the repository root:

```bash
createdb pennine_rail
psql -d pennine_rail -f sql/00_setup.sql
psql -d pennine_rail -P pager=off -f sql/01_explore.sql
psql -d pennine_rail -P pager=off -f sql/02_business_questions.sql
psql -d pennine_rail -P pager=off -f sql/03_aggregation_questions.sql
psql -d pennine_rail -P pager=off -f sql/04_join_questions.sql
psql -d pennine_rail -P pager=off -f sql/05_subquery_questions.sql
psql -d pennine_rail -P pager=off -f sql/06_dates_strings_sets.sql
```

`00_setup.sql` is safe to re-run: it drops and rebuilds the tables.

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
- Of the 41 valid survey ratings, 31 (76%) were Satisfied (4–5). 18 tickets had no response, including all 8 refunded tickets, and one rating of 0 was flagged as invalid and excluded from averages.
- Standard class had a higher average customer rating of 3.91, based on 35 valid survey responses, compared with First class's average of 3.50, based on 6 valid responses. However, this comparison should be treated with caution because First class had a much lower response rate (50%) than Standard class (75%). The smaller number of First class responses means its average may be less representative of all First class passengers' experiences.

**Joins**
- Departures by station: Leeds and York lead with 16 departures each; Bradford and Wakefield have none. Counts total 60, reconciling with the tickets table.
- Advance tickets: Huddersfield and Leeds lead with 6 Advance departures each.
- Data quality: one orphan found. Wakefield's region code `WYK` does not exist in `regions` (likely a typo for `WY`). All ticket origins and destinations match a known station.
- Network structure: Leeds is the hub for four stations; Sheffield's hub is Manchester.
- By region: North Yorkshire has the highest ticket value (£265.00); West Yorkshire has the most departures (27). Humber has no stations.

**Subqueries and CTEs**
- Price: 29 of the 60 tickets sold for more than the network average of £12.61. The most expensive was £51.00 (York → Manchester).
- Customer experience: departures from Huddersfield, Leeds and Manchester received at least one 1–2 star rating.
- Ratings by station: Huddersfield (3.17 from 6 ratings) and Sheffield (3.57 from 7) are rated below the network average of 3.76.
- Hub coverage: five stations (Bradford, Huddersfield, Sheffield, Wakefield, York) are not a hub for any station. A `NOT IN` version of this query returns no rows, because `hub_station_code` contains NULL; `NOT EXISTS` is used instead.
- Departures per station: the 5 stations with departures average 12.0 each. Across all 7 stations the average would be 8.6, because Bradford and Wakefield have none, so the figure depends on which stations are included.
- Departures and arrivals: joining tickets to stations twice multiplies the rows (Huddersfield's 11 departures × 9 arrivals = 99). Counting each side before joining gives the correct figures, which reconcile to 60 departures and 60 arrivals. Manchester receives the most arrivals (20).

**Dates, strings and set operations**
- Booking lead time: Advance tickets are bought 18.1 days ahead on average (up to 27 days); Off-Peak and Anytime tickets are bought within 3 days.
- Daily demand: every day from 1 to 14 October had at least one ticket. The busiest day was Saturday 3 October (8 tickets).
- Station directory: all 7 stations are listed. Wakefield (WKF) is labelled "Region unknown" because its region code `WYK` has no match, rather than being dropped from the list.
- Route balance: all 16 routes sold were also sold in the reverse direction, so there are no one-way routes. This was confirmed with an INTERSECT count, because an empty result alone does not prove the query is correct.
- Network depth: Leeds and Manchester are the only top-level hubs, and every other station is exactly one level below its hub.
- York gaps: York had 16 departures, and no departures on 4 of the 14 days (4, 6, 8 and 14 October). These gaps were found by joining a generated calendar to the tickets.
