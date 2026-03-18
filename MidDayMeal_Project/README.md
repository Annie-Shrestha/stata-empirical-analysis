# Microfinance, Gender & Educational Outcomes — Stata Analysis

**Author:** Annie Shrestha

## Overview

This repository contains Stata do-files for two related empirical analyses:

1. **Gender & Matrilineality in Microfinance** — Examines differences in loan default, risky project choice, strategic default, and risk behavior by gender across matrilineal (Khasi) and patrilineal (Karbi, Bengali) societies in Northeast India.

2. **Mid-Day Meal (MDM) Program & Educational Outcomes** — Evaluates the effect of school meal exposure on children's math and literacy scores using propensity score matching (PSM) and ordered logit regression.

## Repository Structure

```
├── README.md
├── graphs/
│   ├── Graphs_G_M.do        # Bar graphs: gender x society comparisons (Khasi-Karbi & Khasi-Bengali)
│   └── MDM_Graphs.do        # Bar graphs: mean test scores by MDM exposure
└── analysis/
    └── MDM_Annie.do        # Main analysis: variable labels, summary stats, PSM, ologit regressions
```

## Methods

- **Descriptive:** Mean comparisons with 95% confidence intervals by gender and society
- **Propensity Score Matching:** Radius caliper, caliper, kernel, and nearest-neighbor (5NN) methods via `psmatch2`
- **Regression:** Ordered logit with robust standard errors; marginal effects via `margins`
- **Variable Selection:** Double LASSO (`lassoShooting`) for covariate selection

## Outcomes Analyzed

Math test (combined), subtraction, multiplication, division, number recognition, daily task, simple calculation, financial calculation

## Requirements

Stata with the following packages installed:
- `psmatch2` — `ssc install psmatch2`
- `outreg2` — `ssc install outreg2`
- `asdoc` — `ssc install asdoc`

## Data

Data files are not included in this repository. Contact the author for access.
