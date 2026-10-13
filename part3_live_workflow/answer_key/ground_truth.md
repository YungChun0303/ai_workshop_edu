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

The fictional **CNI (Choice Neighborhoods Initiative)** starts in **2019** in ZIP **63106** and five schools (listed in `data_raw/codebook.md`). From 2019 on, Black, low-income families become much more likely to move into 63106 and to enroll in CNI schools, while other families become less likely to move there. Two research questions follow:

1. **Neighborhood:** Did 63106 change (population, racial composition, income)? → synthetic control on the ACS ZIP panel.
2. **Students:** Did students who entered a CNI school, or moved into 63106, do better on MAP tests? → staggered DiD (Callaway & Sant'Anna).

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

MAP scores have linear grade growth (5–6 points a year), common year shocks (a 2021–2023 pandemic dip), student ability, and gaps by FRPL, ELL, and IEP status. Selection into treatment depends only on time-invariant traits, so **parallel trends hold by construction**. From 2019 on, in every year a student is exposed:

| Exposure | Effect on MAP ELA and Math | In SD units (within grade × year SD ≈ 12) |
|---|---|---|
| Enrolled in a CNI school | **+4 points** | ≈ 0.33 SD |
| Living in ZIP 63106 | **+1.5 points** | ≈ 0.12 SD |

Attendance and discipline have **no** planted effect.

Treatment cohorts are defined by first exposure (2019 or later) and are absorbing, so the effect a cohort actually experiences is its average exposure after entry: **3.87 points ≈ 0.32 SD** for the CNI-school cohort and **4.30 points ≈ 0.36 SD** for the ZIP-63106 cohort (most ZIP movers also enroll in CNI schools).

### Neighborhood (ACS ZIP panel)

The ACS file is generated at the ZIP level, so its precision does not depend on the number of simulated students. For ZIP 63106, from 2019 on (t = 1 in 2019, …, 5 in 2023):

| Outcome | Planted change |
|---|---|
| `pop_total` | × (1 + 0.10 t): +10% a year, +50% by 2023 |
| `pct_black` | + 0.035 t: +3.5 pp a year, +17.5 pp by 2023 |
| `median_income` | × (1 − 0.04 t): −4% a year, −20% by 2023 |

ZIP 63106's pre-2019 levels sit inside the range of the donor ZIPs, so a synthetic control can match them.

## Answer-key results (knit 2026-10-12)

### Students: CSDID (`3000_csdid_demo.Rmd`)

`did::att_gt()`, not-yet-treated controls, `allow_unbalanced_panel = TRUE`, simple aggregation. MAP standardized within grade × year.

| Estimate | ELA | Math | Truth |
|---|---|---|---|
| CSDID, CNI-school cohort (SD) | 0.19 (SE 0.09) | 0.29 (SE 0.09) | 0.32 |
| CSDID, ZIP-63106 cohort (SD) | 0.46 (SE 0.15) | 0.45 (SE 0.14) | 0.36 |
| TWFE, CNI school (points) | 3.9 | 4.8 | 4 |
| TWFE, ZIP 63106 (points) | 3.5 | 2.6 | 1.5 |
| **Pitfall:** CSDID on raw points, CNI-school cohort | 8.5 | 10.3 | 3.9 |
| Placebo: attendance rate | −0.005 (school), −0.006 (ZIP) | | 0 |
| Placebo: suspension days | 0.03 (school), −0.42 (SE 0.34, ZIP) | | 0 |

Every 95% CI for the CSDID estimates covers the truth. The event study shows pre-entry estimates near zero.

**The live teaching moment:** with an unbalanced student panel, `att_gt()` falls back to repeated cross-sections and compares each cohort with its own younger, lower-grade self, so grade growth shows up as treatment effect (≈ 9–10 points against a true 4). Standardize within grade × year first. Ask the room whether +10 points is plausible when a year of school is worth 5–6 points.

### Neighborhood: synthetic control (`3100_synth_demo.Rmd`)

`tidysynth`, ACS panel 2014–2023, treatment from 2019, donors = St. Louis City and County ZIPs except 63101, 63103, and 63107 (43 donors). Predictors: pre-period means of the other two ACS measures plus the outcome in 2014, 2016, and 2018.

| Outcome | Gap in 2023 | Planted | Rank | Fisher p |
|---|---|---|---|---|
| Population | +6,970 (+50.7%) | +50% | 1 of 44 | 0.023 |
| Share Black | +0.190 | +0.175 | 1 of 44 | 0.023 |
| Median income | −$13,850 (−19.4%) | −20% | 1 of 44 | 0.023 |

0.023 = 1/44 is the smallest p-value possible with 44 units.

## Things to expect in the live run

- **Descriptive MAP trends are noisy before 2019.** Few cohort students were old enough to be tested in early years, and group membership changes each year. The chart is a picture, not an estimate; the event study is the pre-trend check.
- **The ZIP-63106-only group's raw mean falls after 2019** because the new arrivals are lower-income. This is composition, not a negative effect.
- **Student-level ZIP aggregates are small** (median about 30 students per ZIP-year). That is why synthetic control uses the ACS panel rather than student averages.
- **School-level synthetic control is not recommended:** donor schools lose the families who move into CNI schools, so they are not clean controls (a spillover worth discussing).
