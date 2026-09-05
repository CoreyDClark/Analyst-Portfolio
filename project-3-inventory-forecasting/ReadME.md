# Inventory Optimization & Demand Forecasting

**Tools:** Microsoft Excel — XLOOKUP, AVERAGEIFS/COUNTIFS, IFS, CORREL, PivotTables

---

## Overview

Built entirely in Excel using SKU master data and 26 weeks of weekly demand history across 150 SKUs in 8 outdoor power equipment categories (Chainsaws, Trimmers, Mowers, Blowers, and others).

## Problem

Ollie Inc needed a way to identify which of its 150 SKUs were at the greatest risk of a stockout, in order to minimize lost sales from insufficient inventory. Ollie Inc also wanted to verify that its demand forecasts were reliable, since both overstock and understock carry real financial cost — tied-up cash on one side, lost sales on the other.

## Method

In order to measure stockout risk and verify demand forecast accuracy, SKU data and 26 weeks of demand history were used to derive pertinent KPIs. EOQ, Safety Stock, and Reorder Point were calculated and used to build an inventory model that includes a Risk Tier and Risk Severity percentage. To assess forecast reliability, a 5-week moving average forecast model was built with error tracking. To determine whether demand volatility was related to forecast error, the correlation between the two was calculated.

## Findings

A significant correlation was found between demand volatility and forecast error (**r = 0.77**). Because moving averages cannot accurately track volatile demand, the most volatile SKUs are both the hardest to forecast and the most vulnerable to stockouts — in fact, all 18 SKUs with the highest forecast error (>25%) fell into the Critical-Understock tier.

Separately, the Risk Tier breakdown shows a genuinely two-sided risk profile: 32 SKUs (21%) are Critical-Understock, while 30 SKUs (20%) are Critical-Overstock — meaning meaningful risk exists on both ends of the inventory spectrum, not just stockouts.

## Key Metrics

| Metric | Value |
|---|---|
| Total SKUs analyzed | 150 |
| Critical – Understock | 32 SKUs (21%) |
| Critical – Overstock | 30 SKUs (20%) |
| Overall avg. forecast error (MAPE) | 15.6% |
| Median forecast error | 10.8% |
| Correlation: demand volatility vs. forecast error | r = 0.77 |
| Correlation: current stock vs. reorder point | r = -0.42 |


<img width="1142" height="823" alt="dashboard-screenshot" src="https://github.com/user-attachments/assets/47ee0609-d61c-4fc2-9ee0-e90318593fba" />








