# Pennine Rail — SQL Analysis
SQL analysis of ticket sales data for Pennine Rail, a fictional train operator in the north of England, using PostgreSQL to answer commercial questions about sales, prices and routes.

## Dataset
One table, tickets, at the grain of one row per ticket sold. It covers 60 tickets for journeys between 1 and 14 October 2026.

## Repository structure

```
pennine-rail-sql/
├── README.md
└── sql/
    ├── 00_setup.sql                # creates and loads the tickets table
    ├── 01_explore.sql              # data profiling checks
    └── 02_business_questions.sql   # commercial questions and answers
```

## How to run

Requires PostgreSQL. From the repository root:

```bash
createdb pennine_rail
psql -d pennine_rail -f sql/00_setup.sql
psql -d pennine_rail -P pager=off -f sql/01_explore.sql
psql -d pennine_rail -P pager=off -f sql/02_business_questions.sql
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
