-- Query 1: The Base Truth Table (Capacity & Scheduled Cost)
-- This query merges the dimension table with the scheduled roster to calculate total planned hours per rider.

SELECT  
  Roster.Date,
  Rider.Rider_ID,
  Rider.Vehicle_Type,
  Rider.Hub,
  Rider.Cost_Per_Hour,
  Roster.Scheduled_Start,
  Roster.Scheduled_End,
  TIMESTAMP_DIFF(Roster.Scheduled_End, Roster.Scheduled_Start, HOUR) AS Scheduled_Hours
FROM `turing-seeker-498011-n9.Riyadh_Fleet_WFM_Audit.Dim_Rider` Rider
JOIN `turing-seeker-498011-n9.Riyadh_Fleet_WFM_Audit.Fact_Roster` Roster
  ON Rider.Rider_ID = Roster.Rider_ID
ORDER BY Scheduled_Hours DESC;


-- Query 2: SLA Trap & Adherence Failure (North Riyadh Focus)
-- This query extracts actual application logs to identify specific riders manipulating their status during shifts.

SELECT 
  Rider.Rider_ID,
  Rider.Hub,
  SUM(Logs.Duration_Minutes) AS Total_Wasted_Minutes
FROM `turing-seeker-498011-n9.Riyadh_Fleet_WFM_Audit.Dim_Rider` Rider
JOIN `turing-seeker-498011-n9.Riyadh_Fleet_WFM_Audit.Fact_Rider_Logs` Logs
  ON Rider.Rider_ID = Logs.Rider_ID
WHERE Rider.Hub = 'North Riyadh' 
  AND Logs.App_Status IN ('Break', 'Vehicle Issue')  
GROUP BY 
  Rider.Hub,
  Rider.Rider_ID
ORDER BY Total_Wasted_Minutes DESC;


-- Query 3: Financial Leakage Calculation (The Executive Summary)
-- This query aggregates the total financial loss per hub based on wasted minutes and individual hourly rates.

SELECT 
  Rider.Hub,
  SUM(Logs.Duration_Minutes) AS Total_Wasted_Minutes,
  ROUND(SUM((Logs.Duration_Minutes / 60.0) * Rider.Cost_Per_Hour), 2) AS Total_Financial_Loss_SAR
FROM `turing-seeker-498011-n9.Riyadh_Fleet_WFM_Audit.Dim_Rider` Rider
JOIN `turing-seeker-498011-n9.Riyadh_Fleet_WFM_Audit.Fact_Rider_Logs` Logs
  ON Rider.Rider_ID = Logs.Rider_ID
WHERE Logs.App_Status IN ('Break', 'Vehicle Issue')
GROUP BY 
  Rider.Hub
ORDER BY 
  Total_Financial_Loss_SAR DESC;