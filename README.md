# Click Here to Watch the Interactive Dashboard Demo (https://youtu.be/AKjwaiRWLss)

# WFM Financial Leakage & Adherence Audit: Riyadh Last-Mile Fleet

## Project Overview
This project is an end-to-end Workforce Management (WFM) data model analyzing last-mile delivery fleet operations in Riyadh. The objective is to expose schedule manipulation, intraday SLA failures, and the hidden financial cost of non-adherence during operational hours.

## Business Problem
Delivery fleets experience significant financial leakage due to riders manipulating application statuses (e.g., logging extended unapproved breaks or faking vehicle issues) during peak demand hours. This creates an artificial capacity shortage, forcing operations to incur overtime costs or fail SLA targets, while continuing to pay scheduled hourly rates for unproductive time.

## Data Architecture & Tools
* Data Warehouse: Google BigQuery (SQL)
* Visualization & Analytics: Power BI (DAX)
* Data Schema: Star Schema featuring 1 Dimension table (`Dim_Rider`) and 2 Fact tables (`Fact_Roster`, `Fact_Rider_Logs`).

## Methodology
1. Base Capacity Modeling: Merged rider demographics and cost metrics with scheduled rosters using SQL to establish the baseline financial liability.
2. Anomaly Detection: Queried intraday application logs to isolate illegitimate 'Break' and 'Vehicle Issue' statuses.
3. Financial Translation: Developed DAX measures (`SUMX` and `RELATED`) in Power BI to calculate exact SAR losses by dividing wasted minutes by 60 and multiplying by the specific rider's hourly rate.
4. Executive Dashboarding: Built a control-room style dashboard utilizing rule-based conditional formatting to immediately flag riders exceeding 1,000 SAR in adherence-related financial losses.

## Key Findings
* Identified a massive operational gap in the North Riyadh Hub, generating a financial leakage of 132,183.58 SAR in a single month due to systemic status manipulation.
* Successfully pinpointed specific riders responsible for the highest financial damages, isolating them on an operational blacklist for immediate management intervention.
