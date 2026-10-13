# Codebook — St. Louis School-Mobility Study (Synthetic Data)

**Every record in this folder is simulated** for the AI-Empowered Research workshop. The files mimic the structure of state education records and Census data, but no real student, school, or district data were used. ZIP codes are real St. Louis-area ZIPs so that maps work; every attribute attached to them is fake. District and school names and codes are fictional.

## Study context

The **Choice Neighborhoods Initiative (CNI)**, a fictional neighborhood redevelopment program, began in the **2018–19 school year** (`currentschoolyear = 2019`). It targets one neighborhood, **ZIP 63106**, and five schools in or next to it:

| CNI school | `reportingdistrictcode` | `reportingschoolcode` |
|---|---|---|
| Elementary | 900100 | 1410 |
| Elementary | 900100 | 1560 |
| Elementary | 900100 | 1600 |
| Middle | 900100 | 1930 |
| K-8 Academy | 900200 | 1150 |

CNI status is not a column in any file; identify CNI schools with the district-school codes above.

The study area is **St. Louis City and St. Louis County**. The state files also include some students who live elsewhere in Missouri.

## Files

All files are CSV. Missing values are empty cells.

| File | Unit | Years |
|---|---|---|
| `dese_student_core.csv` | Student × year × enrollment record | 2012–2023 |
| `dese_student_test.csv` | Student × year (MAP tests, grades 3–8) | 2013–2023 |
| `dese_student_enroll.csv` | Student × year × school enrollment | 2013–2023 |
| `dese_student_discipline.csv` | Removal incident | 2013–2023 |
| `building_list.csv` | School | — |
| `dese_school_demo.csv` | School × year | 2012–2023 |
| `acs_zip_panel_mock.csv` | ZIP × year (Census ACS-style estimates for the whole population) | 2014–2023 |

## Variables

### Student files (`dese_student_*.csv`)

| Variable | Description |
|---|---|
| `research_id` | De-identified student ID, stable across years and files |
| `currentschoolyear` | Spring year of the school year (2019 = 2018–19) |
| `seq` | Record sequence within a student-year; a higher number is a later record |
| `reportingdistrictcode`, `reportingschoolcode` | District and school codes; a school is identified by the pair |
| `studentgradelevel` | Grade: 0 = kindergarten, 1–12 |
| `gender` | 1 Female, 2 Male |
| `raceethnicity` | 1 Black, 2 White, 3 Hispanic, 4 Asian, 5 Multiracial |
| `zipcode` | Home ZIP code (text) |
| `lunchstatus` | 0 Not eligible, 1 Free lunch, 2 Reduced-price lunch |
| `lepell` | English language learner: 0 No, 1 Yes |
| `iepdisability` | Primary IEP disability: 0 None (no IEP), 1 Specific learning disability, 2 Speech/language, 3 Other health impairment, 4 Autism, 5 Emotional disturbance, 6 Intellectual disability |
| `map_score1`, `map_score2` | MAP scale score, English language arts and Math. **Scores of 2000 or more carry an administrative flag; subtract 2000 to get the scale score.** |
| `daysenrolled` | Days enrolled at that school in that year |
| `attendancerate` | Share of enrolled days attended at that school (0–1) |
| `disciplineremoval` | Removal type: 1 In-school suspension (ISS), 2 Out-of-school suspension (OSS), 3 Unilateral removal, 4 Expulsion |
| `lengthremoved` | Length of the removal in days |

### School files

| Variable | Description |
|---|---|
| `CTYDIST`, `SCHNUM` | District and school codes (match `reportingdistrictcode`, `reportingschoolcode`) |
| `DISTNAME`, `SCHNAME` | District and school names |
| `SCHZIP` | School ZIP code (text) |
| `ELEM SCHOOL`, `MIDDLE SCHOOL`, `HIGH SCHOOL` | School level flags (Y/N) |
| `enroll_demo` | Total enrollment |
| `enroll_black`, `enroll_frl` | Enrollment of Black students and of students eligible for free or reduced-price lunch |

### ACS ZIP panel (`acs_zip_panel_mock.csv`)

| Variable | Description |
|---|---|
| `zip` | ZIP code (St. Louis City and County only) |
| `year` | Estimate year |
| `pop_total` | Total population |
| `pct_black` | Share of residents who are Black (0–1) |
| `median_income` | Median household income (dollars) |
