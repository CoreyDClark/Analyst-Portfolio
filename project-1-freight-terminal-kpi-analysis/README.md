# Freight Terminal KPI Analysis: Why Is Atlanta Central (T2) Falling Behind?

**Author:** Corey Clark
**Tools:** SQL Server (T-SQL), Power BI Desktop
**Dataset:** 458 shipments across 6 terminals, 24 drivers, 10 shippers, Jan–Jun 2026

---

## Business Question

Which terminal(s) in the network are underperforming on on-time departures, and why? This analysis was built to answer the kind of question a freight operations manager would actually ask in a stand-up meeting — not just "what's late," but "why is it late, and what should we do about it."

## Dashboard

<img width="1505" height="813" alt="Screenshot 2026-08-18 133057" src="https://github.com/user-attachments/assets/9b572f18-fa8d-4b02-8007-54de31de1de1" />

---

## Data Quality & Validation

I ran several validation checks before drawing a conclusion based upon this dataset. The data in the `ScheduledDeparture` and `ActualDeparture` columns needed to be handled carefully to calculate accurate delay times — I used `DATEDIFF`/`DATEPART` to calculate delays in minutes between scheduled and actual departure.

To determine whether the T2 average delay (62 minutes) wasn't skewed by data errors, I checked the top 10 outliers individually and confirmed they were plausible operational events (162–180 minutes), and not errors. I also caught and corrected a join error that was silently inflating shipment totals before I trusted any terminal-level numbers. I originally theorized that one driver's elevated average departure delay indicated an individual performance issue; that didn't hold up once I compared sample sizes among the other drivers at T2.

## Key Finding

Atlanta Central (T2) departs late 62% of the time averaging 62 minutes behind schedule, more than 3x worse than any other terminal in the network. T2 has the highest shipments-per-manhour of all six terminals, so the delays are not a result of a workforce capacity issue. There wasn't enough evidence to conclude the departure delays were caused by any one driver or shipper, so it looks like a systemic pattern. At T2, all four drivers' average departure delay times are elevated, and 6 of the 10 shippers using T2 have an average departure delay of over an hour.

Departure delays also increase throughout the day: T2's average delay grows from ~51 minutes in the morning to ~74 minutes in the afternoon. Driver D008, who moves about 33% of T2's total shipments, shows an afternoon increase in departure delay times that's much higher than the other drivers at T2. Also, worth flagging as part of the deeper root-cause analysis.

I would conclude that the elevated departure delays at T2 are either a result of unrealistic departure scheduling or something upstream, like inbound arrival times. The data is insufficient to determine which of the possible root causes is correct.

## Recommendation

I would recommend an audit of T2's scheduled departure times to determine if they are realistic given actual dock and route conditions. I would also recommend that the inbound-arrival timestamps, if available, be pulled; this will allow T2 to determine if there is an upstream timing problem as opposed to a scheduling design issue. The current data confirms that something structural at T2 is causing departure delays, but is not definitive enough to determine whether the cause is scheduling design or upstream timing. Separately, I'd recommend D008's afternoon departure pattern be reviewed, as it's significantly higher than the other drivers' at T2.

---

## Methodology Highlights

A couple of technical decisions worth noting for anyone reviewing this project:

- **Time calculations:** `ScheduledDeparture`/`ActualDeparture` are stored as `time` values. I used `DATEDIFF(MINUTE, ScheduledDeparture, ActualDeparture)` to calculate delay minutes, and `DATEPART(HOUR, ScheduledDeparture)` to bucket shipments into Morning/Afternoon for the time-of-day analysis. See `queries.sql` for the full pattern.
- **Caught and corrected a join fan-out bug:** an early query joined `Terminals to Drivers to Shipments` on `TerminalID` alone, which silently multiplied shipment counts by each terminal's driver count. Caught by cross-checking totals, and fixed by joining `Shipments` directly to `Terminals` on the correct key.

**Sample query** : (full set of 6 in [`queries.sql`](queries.sql))

```sql
SELECT
    TerminalID,
    COUNT(*) AS TotalShipments,
    SUM(CASE WHEN ActualDeparture > ScheduledDeparture THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS LateShipmentPct
FROM Shipments
GROUP BY TerminalID
ORDER BY LateShipmentPct DESC;
```

## Files in This Project

| File | Description |
|---|---|
| `README.md` | This file — project overview, findings, and recommendation |
| `queries.sql` | All 6 SQL queries used in the investigation (T-SQL / SQL Server) |
| `dashboard_screenshot.png` | Final Power BI dashboard |
| `T2_Terminal_Dashboard.pbix` | Power BI dashboard file |

