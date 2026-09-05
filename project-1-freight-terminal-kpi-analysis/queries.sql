/* ============================================================
   Project 1: Freight Terminal KPI Analysis — T2 Departure Delay Investigation
   Database: SQL Server (T-SQL)
   Author: Corey Clark
   ============================================================ */

-- ------------------------------------------------------------
-- Query 1: Terminal Comparison
-- Purpose: Identify which terminal(s) have the highest late-departure %
-- ------------------------------------------------------------
SELECT
    TerminalID,
    COUNT(*) AS TotalShipments,
    SUM(CASE WHEN ActualDeparture > ScheduledDeparture THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS LateShipmentPct
FROM Shipments
GROUP BY TerminalID
ORDER BY LateShipmentPct DESC;


-- ------------------------------------------------------------
-- Query 2: Driver Breakdown at T2
-- Purpose: Determine whether T2's lateness is concentrated in one driver
--          or spread systemically across all drivers
-- ------------------------------------------------------------
SELECT
    DriverID,
    COUNT(*) AS TotalShipments,
    AVG(DATEDIFF(MINUTE, ScheduledDeparture, ActualDeparture)) AS AvgDelayMinutes
FROM Shipments
WHERE TerminalID = 'T2'
GROUP BY DriverID
ORDER BY AvgDelayMinutes DESC;


-- ------------------------------------------------------------
-- Query 3: Shipper Breakdown at T2
-- Purpose: Determine whether T2's lateness is concentrated in one shipper
--          or spread systemically across all shippers
-- ------------------------------------------------------------
SELECT
    SH.ShipperName,
    COUNT(*) AS TotalShipments,
    AVG(DATEDIFF(MINUTE, S.ScheduledDeparture, S.ActualDeparture)) AS AvgDelayMinutes
FROM Shipments S
INNER JOIN Shippers SH ON S.ShipperID = SH.ShipperID
WHERE S.TerminalID = 'T2'
GROUP BY SH.ShipperName
ORDER BY AvgDelayMinutes DESC;


-- ------------------------------------------------------------
-- Query 4: Capacity Check (Shipments per Man-Hour by Terminal)
-- Purpose: Rule out workforce capacity/staffing strain as the root cause
-- ------------------------------------------------------------
SELECT
    T.TerminalID,
    T.TerminalName,
    COUNT(S.ShipmentID) AS TotalShipments,
    SUM(S.ManHours) AS TotalManHours,
    COUNT(S.ShipmentID) / SUM(S.ManHours) AS ShipmentsPerManHour
FROM Terminals T
JOIN Shipments S ON S.TerminalID = T.TerminalID
GROUP BY T.TerminalID, T.TerminalName
ORDER BY ShipmentsPerManHour DESC;


-- ------------------------------------------------------------
-- Query 5: Time-of-Day Split at T2
-- Purpose: Check whether delays compound over the course of the day
-- ------------------------------------------------------------
SELECT
    CASE WHEN DATEPART(HOUR, ScheduledDeparture) < 12 THEN 'Morning' ELSE 'Afternoon' END AS PartOfDay,
    COUNT(*) AS TotalShipments,
    AVG(DATEDIFF(MINUTE, ScheduledDeparture, ActualDeparture)) AS AvgDelayMinutes
FROM Shipments
WHERE TerminalID = 'T2'
GROUP BY CASE WHEN DATEPART(HOUR, ScheduledDeparture) < 12 THEN 'Morning' ELSE 'Afternoon' END;


-- ------------------------------------------------------------
-- Query 6: Driver x Time-of-Day at T2
-- Purpose: Determine whether the afternoon slowdown hits all drivers evenly,
--          or is concentrated in a specific driver (surfaced the D008 finding)
-- ------------------------------------------------------------
SELECT
    DriverID,
    CASE WHEN DATEPART(HOUR, ScheduledDeparture) < 12 THEN 'Morning' ELSE 'Afternoon' END AS PartOfDay,
    COUNT(*) AS TotalShipments,
    AVG(DATEDIFF(MINUTE, ScheduledDeparture, ActualDeparture)) AS AvgDelayMinutes
FROM Shipments
WHERE TerminalID = 'T2'
GROUP BY DriverID, CASE WHEN DATEPART(HOUR, ScheduledDeparture) < 12 THEN 'Morning' ELSE 'Afternoon' END
ORDER BY DriverID, CASE WHEN DATEPART(HOUR, ScheduledDeparture) < 12 THEN 'Morning' ELSE 'Afternoon' END;
