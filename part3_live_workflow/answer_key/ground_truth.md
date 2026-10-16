# Ground Truth — Instructor Reference (Synthetic St. Louis Data)

**Do not give this folder to Claude during the live demo.** It contains the effects built into the data and the finished analysis. Run the demo on a copy of `part3_live_workflow/` without `answer_key/`.

The data are synthetic and the results hypothetical. They are deliberately cleaner than a real evaluation: Part 3 demonstrates the *workflow*, not a finding.

## Regenerate the data

```bash
# from part3_live_workflow/
Rscript answer_key/generate_mock_data.R
```

Seeded (`set.seed(20261016)`), takes a few seconds, needs `dplyr`, `tidyr`, and `here`. Overwrites the seven CSV files in `data_raw/` (the codebook is left alone).

## The story

The fictional **CNI (Choice Neighborhoods Initiative)** starts in **2019** in ZIP **63106** and five schools (listed in `data_raw/codebook.md`). Two research questions follow:

1. **Neighborhood:** Did 63106 change (population, racial composition, income)? → synthetic control on the ACS ZIP panel. *Planted story:* redevelopment temporarily displaces residents (population dips in 2019 and recovers by 2021), the racial composition does not change, and incomes rise from 2021 on.
2. **Students:** Did students who entered a CNI school, or moved into 63106, do better on MAP tests? → staggered DiD (Callaway & Sant'Anna). *Planted story:* a quick gain that peaks in the third year in a CNI school, then settles at a smaller lasting effect.

*Revised 2026-10-15* (the effects were changed for teaching; the data stay synthetic). Student moves were left as before, so all data issues and counts below are unchanged; the ACS ZIP panel is generated separately, so the neighborhood story comes from it.

Sizes: 4,400 students (4,000 who live in St. Louis City/County, 400 out of area); 23,077 core records; 21,815 enrollment rows; 2,652 discipline incidents; 7,051 test rows; 54 schools in 6 districts; 470 ACS ZIP-years (47 ZIPs, 2014–2023).

## Built-in data issues (what cleaning should find)

The codebook documents items 1 and 5, as a real data dictionary would. The others are left for the audit step to discover.

1. **Multiple records per student-year.** Mid-year movers have a `seq = 1` record (old school/ZIP) and a `seq = 2` record. Keep the highest `seq`. *(documented)*
2. **Years before 2014** (2012–2013) are present; the analysis period starts in 2014.
3. **ZIP codes** are text: about 15% are ZIP+4 (`63106-1234`), about 2% are blank.
4. **Out-of-area students** (Kansas City `641xx`, Columbia `652xx`, Springfield `658xx`) must be dropped.
5. **MAP scores** of 2000 or more carry a +2000 flag (`2195` means `195`); about 4% of scores. *(documented)*
6. **No MAP tests in 2020**; some students miss one subject.
7. **Discipline is long** (one row per incident); a few `lengthremoved` values are missing; students with no row had no removals. A single 180-day expulsion makes total removal days noisy, so use suspension days (ISS + OSS).
8. **Enrollment has two rows** for mid-year movers; collapse to one row per student-year, weighting `attendancerate` by `daysenrolled`.

Cleaning all eight yields **15,737 student-years for 3,975 students** (`answer_key/code/1000_clean_demo.Rmd`).

## Planted effects

### Students (MAP scores)

MAP scores have linear grade growth (5–6 points a year), common year shocks (a 2021–2023 pandemic dip), student ability, and gaps by FRPL, ELL, and IEP status. Selection into treatment depends only on time-invariant traits, so **parallel trends hold by construction**.

The effect depends on **years since a student first entered a CNI school** (2019 or later) and is **absorbing**: it stays with the student after they leave. Living in ZIP 63106 has **no** separate effect.

| Year since first CNI-school entry | 1 | 2 | 3 | 4 and later |
|---|---|---|---|---|
| Planted, MAP ELA (points) | +5 | +9 | +13.5 | **+7.5** |
| Planted, MAP Math (points) | +5 | +9 | +13.5 | **+6** |
| What the CSDID event study shows (ELA / Math, points) | +4.2 / +4.6 | +7.0 / +8.0 | **+12.9 / +13.8** | **+4.6 / +4.7** (year 5: +4.3 / +4.9) |

Why year 4+ is planted higher for ELA: with an unbalanced student panel, `att_gt()` falls back to comparing repeated cross-sections, and in years 4–5 only the 2019 and 2020 entry cohorts remain, so which of their students are in tested grades shifts as they age. That composition shift pulls the late ELA estimates down by about 3 points (Math by about 1). The planted values were tuned so the event study **shows** about +4–6 points from year 4 on in both subjects. In SD units (within grade × year SD ≈ 12), the peak is about 1.1 SD.

**Not a realistic effect size.** The year-3 peak (about 1.1 SD) is deliberately exaggerated so the effect is easy to see in a small synthetic sample. Real education interventions are much smaller: Kraft (2020, *Educational Researcher* 49(4), 241–253) treats effects under 0.05 SD as small, 0.05–0.20 SD as medium, and 0.20 SD or more as large. In real data, an estimate above 1 SD should prompt an error check before interpretation.

Attendance and discipline have **no** planted effect.

### Neighborhood (ACS ZIP panel)

The ACS file is generated at the ZIP level, so its precision does not depend on the number of simulated students. For ZIP 63106, relative to its own trend:

| Outcome | 2019 | 2020 | 2021 | 2022 | 2023 |
|---|---|---|---|---|---|
| `pop_total` | **−12%** | **−4%** | 0 | 0 | 0 |
| `pct_black` | 0 | 0 | 0 | 0 | 0 |
| `median_income` | 0 | 0 | **+6%** | **+9%** | **+12%** |

ZIP 63106's pre-2019 levels sit inside the range of the donor ZIPs, so a synthetic control can match them.

## Answer-key results (knit 2026-10-15)

### Students: CSDID (`3000_csdid_demo.Rmd`)

`did::att_gt()`, not-yet-treated controls, `allow_unbalanced_panel = TRUE`, rows with a missing outcome dropped before estimation. MAP standardized within grade × year. **No convergence, optimizer, or singular-matrix warnings**; the only messages are `did`'s informational "No units in group … in time period …" (later cohorts have no tested students in early years).

**Event study (standardized estimate converted to points; years since entry):**

| | Year 1 | Year 2 | Year 3 | Year 4 | Year 5 |
|---|---|---|---|---|---|
| ELA | +4.2 | +7.0 | **+12.9** | +4.6 | +4.3 |
| Math | +4.6 | +8.0 | **+13.8** | +4.7 | +4.9 |
| Raw-points CSDID, ELA (pitfall) | +8.3 | +13.2 | **+23.1** | +8.9 | +12.7 |
| Raw-points CSDID, Math (pitfall) | +9.5 | +14.9 | **+25.1** | +8.8 | +14.1 |

Pre-entry estimates are near zero (event time −1: about −0.15 SD, CI covers 0).

| Estimate | ELA | Math | Planted average |
|---|---|---|---|
| CSDID simple ATT, CNI-school cohort (SD) | 0.56 (SE 0.08) | 0.61 (SE 0.09) | 0.70 / 0.67 |
| CSDID simple ATT, ZIP-63106 cohort (SD) | 0.54 (SE 0.15) | 0.51 (SE 0.14) | 0.55 / 0.52 (via CNI schools only) |
| TWFE, CNI school (points) | 7.6 | 8.4 | 8.5 / 8.1 |
| TWFE, ZIP 63106 (points) | 2.0 | 1.3 | 0 |
| **Pitfall:** raw-points CSDID, CNI-school cohort (points) | 13.4 | 14.6 | 8.5 / 8.1 |
| Placebo: attendance rate | −0.005 (school), −0.006 (ZIP) | | 0 |
| Placebo: suspension days | 0.03 (school), −0.42 (SE 0.33, ZIP) | | 0 |

The 95% CIs of the CSDID ATTs cover the planted averages. The ZIP cohort's effect comes entirely through CNI schools (most students who move into 63106 also enroll in one), which is the Step 05 "overstated" point.

**The live teaching moment (reframed):** estimating on raw points counts normal grade growth as program effect, so the raw estimates run well above the standardized ones: **+23 to +25 points in year 3, against +13 to +14 standardized.** Ask the room: "If a year of school is worth 5–6 points, which of these is measuring the program?" Standardize within grade × year first.

### Neighborhood: synthetic control (`3100_synth_demo.Rmd`)

`tidysynth`, ACS panel 2014–2023, treatment from 2019, donors = St. Louis City and County ZIPs except 63101, 63103, and 63107 (43 donors). Predictors: pre-period means of the other two ACS measures plus the outcome in 2014, 2016, and 2018. **No warnings.**

| Outcome | 2019 | 2020 | 2021 | 2022 | 2023 | Rank | Fisher p |
|---|---|---|---|---|---|---|---|
| Population (gap, % of synthetic) | **−11.7%** | **−4.0%** | −0.1% | −0.6% | +0.5% | 2 of 44 | 0.045 |
| Share Black (gap, proportion) | +0.005 | +0.004 | +0.016 | +0.021 | +0.015 | 6 of 44 | 0.136 |
| Median income (gap, %) | −2.1% | −1.5% | +3.1% | **+8.9%** | **+12.9%** | 1 of 44 | 0.023 |

Rank and Fisher p use the ratio of post- to pre-period fit (RMSPE); 0.023 = 1/44 is the smallest p possible with 44 units. Share Black stays inside the placebo cloud (no effect, as planted); the population dip and the income rise stand out.

## Things to expect in the live run

- **Descriptive MAP trends are noisy before 2019.** Few cohort students were old enough to be tested in early years, and group membership changes each year. The chart is a picture, not an estimate; the event study is the pre-trend check.
- **The ZIP-63106-only group's raw mean falls after 2019** because the students who move in are lower-income (student moves were not changed in the 2026-10-15 revision). This is composition, not a negative effect.
- **Student-level ZIP aggregates are small** (median about 30 students per ZIP-year). That is why synthetic control uses the ACS panel rather than student averages.
- **The aggregate ATT hides the shape.** The simple average (about 0.6 SD) blends a year-3 peak with a smaller lasting effect; read the event study.
- **School-level synthetic control is not recommended:** donor schools lose the families who move into CNI schools, so they are not clean controls (a spillover worth discussing).
