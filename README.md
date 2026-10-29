# Pennine Rail — SQL Analysis
SQL analysis of ticket sales data for Pennine Rail, a fictional train operator in the north of England, using PostgreSQL to answer commercial questions about sales, prices routes and customer satisfaction.

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
    ├── 00_setup.sql                # creates and loads the tickets table
    ├── 01_explore.sql              # data profiling checks
    ├── 02_business_questions.sql   # commercial questions and answers
    ├── 03_aggregation_questions.sql # grouped totals, rating bands and averages
    └── 04_join_questions.sql        #multi-table analysis and referential integrity checks
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
```

`00_setup.sql` is safe to re-run: it drops and rebuilds the table.

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
