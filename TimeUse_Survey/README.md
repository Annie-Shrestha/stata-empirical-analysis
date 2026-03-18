# Time Use & Intra-Household Inequality — WIL Minigrant Project

**Author:** Annie Shrestha

## Overview

This repository contains Stata do-files for two related empirical analyses examining time use and intra-household resource allocation:

1. **Vietnam VHLSS Panel (2010–2012)** — Cleans and merges household survey data on non-farm businesses, farm businesses, and spousal characteristics across two waves of the Vietnam Household Living Standards Survey.

2. **Cross-Country Time-Use Analysis** — Processes time-use survey data across Sub-Saharan Africa and Asia to analyze gender differences in paid work, unpaid domestic work, and care work.

## Repository Structure

```
├── README.md
│
├── vietnam/
│   ├── spousal_characteristics_2010.do          # Spousal characteristics, 2010 VHLSS
│   ├── spousal_characteristics_2012.do          # Spousal characteristics, 2012 VHLSS
│   ├── nonfarm_business_2010.do          # Non-farm business cleaning, 2010
│   ├── nonfarm_business_2012.do          # Non-farm business cleaning, 2012
│   ├── farmnonfarm_business_2010.do      # Farm business cleaning, 2010
│   ├── farmnonfarm_business_2012.do      # Farm business cleaning, 2012
│   └── merge_vhlss_2010_2012.do      # Merge 2010 and 2012 waves
│
└── time-use/
    ├── timeuse_southafrica_2010.do     # South Africa TUS 2010
    ├── timeuse_southafrica_2000.do  # South Africa TUS 2000
    ├── timeuse_morocco_2012.do       # Morocco TUS 2012
    ├── timeuse_kenya_2021.do          # Kenya TUS 2021
    └── timeuse_vietnam_2022.do        # Vietnam TUS 2022
```

## Methods

- Household-level panel construction via matched spouse identifiers
- Income aggregation across farm and non-farm business modules
- Time-use diary processing: activity classification into market work, domestic work, and care work
- Cross-country harmonization of activity codes (ICATUS)

## Data

Raw data files are not included. Contact the author for access.

## Requirements

Stata (version 15+)
