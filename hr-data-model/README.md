# HR Data Model Design

A normalized data model built to unify fragmented HR data and support workforce decision-making across the employee lifecycle.

## Problem

Most People teams operate on disconnected data — separate sources for headcount, compensation, job changes, and attrition — with no shared structure. This leads to inconsistent reporting, duplicated logic, and a limited ability to reliably answer workforce questions.

## Data Model

The model introduces a dimensional structure designed to serve as the foundational layer for People Systems reporting and planning:

- **Employee dimension** — canonical employee record across systems, resolving identity and status fragmentation
- **Department dimension** — org structure mapping that supports rollups, cost center alignment, and reporting hierarchies
- **Job history tracking** — slowly changing records that preserve role, level, and manager transitions over time
- **HR fact tables** — event-level records for hires, terminations, promotions, and transfers, built for metric consistency
- **Workforce snapshots** — point-in-time state tables enabling period-over-period comparisons and trend analysis

## What This Enables

- Headcount reporting with a single source of truth across business units
- Attrition and retention analysis grounded in consistent tenure and exit logic
- Promotion and internal mobility tracking tied to actual job history, not survey data
- Workforce planning inputs based on historical patterns rather than static assumptions
