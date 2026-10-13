# =============================================================================
# generate_mock_data.R
# Synthetic raw data for "AI-Empowered Research" (CERP3 workshop, Part 3).
#
# Modeled on the STRUCTURE of a St. Louis school-mobility evaluation
# (student-year panel, staggered neighborhood/school intervention, CSDID).
# Every record below is simulated. No real students, schools, or districts.
# ZIP codes are real public St. Louis-area ZIPs so maps work; all ZIP-level
# attributes attached to them are fake.
#
# Run from anywhere in the Part 3 project:   Rscript answer_key/generate_mock_data.R
# Output:   data_raw/  (7 CSV files; codebook in data_raw/codebook.md,
#           planted effects in answer_key/ground_truth.md)
#
# Every file is CSV, and each keeps only the variables the workshop analysis
# uses (CSDID on student outcomes, synthetic control on ZIPs and schools).
# Categorical variables are numeric codes; data_raw/codebook.md is the codebook.
# =============================================================================

suppressPackageStartupMessages({
  library(dplyr)
  library(tidyr)
  library(here)
})

set.seed(20261016)
out_dir <- here::here("data_raw")
dir.create(out_dir, showWarnings = FALSE)

# ---- 1. Parameters ----------------------------------------------------------
N_STL         <- 4000   # students who live in STL City/County at some point
N_OTHER       <- 400    # out-of-area students (the cleaning step should drop them)
YEARS         <- 2012:2023
POLICY_YR     <- 2019   # intervention starts
CNI_ZIP       <- 63106  # treated neighborhood
EFFECT_SCHOOL <- 4      # MAP points while enrolled in a CNI school, year >= 2019
EFFECT_NEIGH  <- 1.5     # MAP points while living in ZIP 63106,  year >= 2019

# ---- 2. Geography -----------------------------------------------------------
zip_city   <- c(63101, 63102, 63103, 63104, 63106, 63107, 63108, 63109, 63110,
                63111, 63112, 63113, 63115, 63116, 63118, 63139, 63147)
zip_north  <- c(63031, 63033, 63034, 63114, 63121, 63133, 63134, 63135, 63136, 63138)
zip_mid    <- c(63105, 63117, 63119, 63122, 63124, 63130, 63131, 63132, 63141, 63144, 63146)
zip_south  <- c(63011, 63017, 63021, 63123, 63125, 63126, 63127, 63128, 63129)
zip_county <- c(zip_north, zip_mid, zip_south)
zip_other  <- c(64108, 64111, 64131, 65201, 65203, 65802, 65807)

zips <- tibble(
  zip    = c(zip_city, zip_county, zip_other),
  region = rep(c("city", "county", "other"),
               c(length(zip_city), length(zip_county), length(zip_other)))
)
zips$w <- rgamma(nrow(zips), shape = 4, rate = 4)
zips$w[zips$zip == CNI_ZIP] <- 0.6            # small neighborhood before 2019

county_dist <- c(setNames(rep(900310, length(zip_north)), zip_north),
                 setNames(rep(900320, length(zip_mid)),   zip_mid),
                 setNames(rep(900330, length(zip_south)), zip_south))

districts <- tibble(
  dist     = c(900100, 900200, 900310, 900320, 900330, 900900),
  distname = c("Confluence City Public Schools", "Lumen Charter Academy",
               "North Oakridge County SD", "Prairie Crest County SD",
               "Willow Run County SD", "Outstate Unified SD")
)

# ---- 3. Schools (fictional names, codes, and addresses) ---------------------
grade_span <- list(elem = c(0, 5), middle = c(6, 8), high = c(9, 12), k8 = c(0, 8))

make_schools <- function(dist, pool, n_elem, n_mid, n_high) {
  tibble(
    dist  = dist,
    level = rep(c("elem", "middle", "high"), c(n_elem, n_mid, n_high)),
    zip   = c(sample(pool, n_elem, replace = n_elem > length(pool)),
              sample(pool, n_mid,  replace = n_mid  > length(pool)),
              sample(pool, n_high, replace = n_high > length(pool))),
    cni   = 0L
  )
}

schools <- bind_rows(
  # Five CNI (treated) schools, all in or next to ZIP 63106
  tibble(dist = 900100, level = c("elem", "elem", "elem", "middle"),
         zip = c(63106, 63106, 63107, 63106), cni = 1L),
  tibble(dist = 900200, level = "k8", zip = 63106, cni = 1L),
  # Everyone else
  make_schools(900100, setdiff(zip_city, CNI_ZIP), 12, 4, 3),
  tibble(dist = 900200, level = "high", zip = 63108, cni = 0L),
  make_schools(900310, zip_north, 5, 2, 1),
  make_schools(900320, zip_mid,   5, 2, 1),
  make_schools(900330, zip_south, 5, 2, 1),
  make_schools(900900, zip_other, 3, 1, 1)
) %>%
  group_by(dist) %>%
  mutate(sch = sort(sample(seq(1010, 7990, by = 10), n()))) %>%
  ungroup() %>%
  mutate(
    sid = row_number(),
    lo  = vapply(level, function(l) grade_span[[l]][1], numeric(1)),
    hi  = vapply(level, function(l) grade_span[[l]][2], numeric(1))
  )

name_pool <- c("Alder", "Aspen", "Bayberry", "Birch", "Bluebell", "Briar", "Buckeye",
               "Cardinal", "Cedar", "Chestnut", "Clover", "Cobblestone", "Cottonwood",
               "Cypress", "Dogwood", "Driftwood", "Elmhurst", "Fernwood", "Fieldstone",
               "Foxglove", "Goldfinch", "Hawthorn", "Hazel", "Heron", "Hickory",
               "Holly", "Ironwood", "Juniper", "Kestrel", "Larkspur", "Laurel",
               "Linden", "Magnolia", "Maplecrest", "Meadowlark", "Mulberry", "Oakmont",
               "Osage", "Pawpaw", "Pinecrest", "Primrose", "Quailridge", "Redbud",
               "Rosewood", "Sassafras", "Sparrow", "Spruce", "Stonebridge", "Sumac",
               "Sycamore", "Tamarack", "Thistle", "Trillium", "Tupelo", "Walnut",
               "Willowbrook", "Wren", "Yarrow")
level_word <- c(elem = "Elementary", middle = "Middle", high = "High", k8 = "K-8 Academy")
schools$schname <- paste(sample(name_pool, nrow(schools)), level_word[schools$level])

# ---- 4. Students (time-invariant traits) ------------------------------------
draw_students <- function(n, region) {
  kyear <- sample(2000:2023, n, replace = TRUE)       # kindergarten year
  fy    <- pmax(kyear, min(YEARS))
  ly    <- pmin(kyear + 12, max(YEARS))
  late  <- runif(n) > 0.55                            # enters mid-way
  start <- ifelse(late, fy + floor(runif(n) * (ly - fy + 1)), fy)
  stop  <- pmin(ly, start + rgeom(n, 0.06))           # ~6% annual attrition
  p_race <- switch(region,
    city   = c(.72, .18, .04, .03, .03),
    county = c(.30, .55, .05, .05, .05),
    other  = c(.15, .70, .08, .03, .04))
  race <- sample(1:5, n, replace = TRUE, prob = p_race)  # 1 Black ... 5 Multi
  tibble(kyear, start, stop, race,
         region0 = region,
         male    = rbinom(n, 1, 0.51),
         frl     = rbinom(n, 1, plogis(-0.6 + 1.2 * (race == 1) + 0.6 * (race == 3) +
                                         0.8 * (region == "city"))),
         immig   = rbinom(n, 1, ifelse(race %in% 3:4, 0.25, 0.02))) %>%
    mutate(ell     = rbinom(n, 1, ifelse(immig == 1, 0.6, ifelse(race == 3, 0.2, 0.01))),
           iep     = rbinom(n, 1, 0.13),
           iepcode = ifelse(iep == 1, sample(1:6, n, TRUE, c(.38, .22, .16, .10, .07, .07)), 0),
           ability = rnorm(n, -0.25 * frl),
           absent  = rnorm(n)) %>%
    filter(start <= stop, stop >= 2014)
}

stl_pool <- bind_rows(draw_students(N_STL, "city"), draw_students(N_STL, "county")) %>%
  slice_sample(n = N_STL)
oth_pool <- draw_students(N_OTHER * 2, "other") %>% slice_head(n = N_OTHER)
st <- bind_rows(stl_pool, oth_pool)
n  <- nrow(st)
st$research_id <- sample.int(9e8, n) + 1e8
st$region <- st$region0
st$zip    <- NA_real_
st$dist   <- NA_real_
st$sid    <- NA_integer_
st$seen   <- FALSE

# ---- 5. Choice helpers ------------------------------------------------------
pick_zip <- function(region, boost) {
  z <- zips[zips$region == region, ]
  w <- z$w * ifelse(z$zip == CNI_ZIP, boost, 1)
  z$zip[sample.int(nrow(z), 1, prob = w)]
}

pick_dist <- function(zip, region, cur) {
  if (region == "other")  return(900900)
  if (region == "county") return(unname(county_dist[as.character(zip)]))
  if (!is.na(cur) && cur == 900200 && runif(1) < 0.8) return(900200)
  sample(c(900100, 900200, 900310, 900320, 900330), 1,
         prob = c(.82, .13, .02, .02, .01))           # last three = transfer program
}

pick_school <- function(dist, grade, zip, t, priority) {
  cand <- schools[schools$dist == dist & schools$lo <= grade & schools$hi >= grade, ]
  w <- 1 + 4 * (cand$zip == zip) +
    ifelse(t >= POLICY_YR & cand$cni == 1, 1 + 6 * priority, 0)
  cand$sid[sample.int(nrow(cand), 1, prob = w)]
}

# ---- 6. Simulate the student-year panel -------------------------------------
recs <- vector("list", length(YEARS))
for (k in seq_along(YEARS)) {
  t     <- YEARS[k]
  grade <- t - st$kyear
  act   <- t >= st$start & t <= st$stop & grade >= 0 & grade <= 12
  new   <- act & !st$seen
  prev_zip <- st$zip
  prev_sid <- st$sid
  prev_dist <- st$dist
  priority <- st$race == 1 & st$frl == 1   # Black, low-income families
  move  <- act & st$seen & runif(n) < ifelse(st$frl == 1, 0.14, 0.08)

  for (i in which(new | move)) {
    reg <- st$region[i]
    if (move[i] && reg != "other" && runif(1) < 0.07) reg <- setdiff(c("city", "county"), reg)
    st$region[i] <- reg
    st$zip[i]  <- pick_zip(reg, if (t >= POLICY_YR) (if (priority[i]) 12 else 0.4) else 1)
    st$dist[i] <- pick_dist(st$zip[i], reg, if (new[i]) NA else st$dist[i])
  }

  serves <- !is.na(st$sid) & schools$lo[pmax(st$sid, 1)] <= grade &
    schools$hi[pmax(st$sid, 1)] >= grade & schools$dist[pmax(st$sid, 1)] == st$dist
  need <- act & (new | is.na(st$sid) | !serves | (st$dist != coalesce(prev_dist, -1)) |
                   runif(n) < 0.04)
  for (i in which(need)) {
    st$sid[i] <- pick_school(st$dist[i], grade[i], st$zip[i], t, priority[i])
  }

  idx <- which(act)
  recs[[k]] <- tibble(
    i = idx, currentschoolyear = t, grade = grade[idx],
    zip = st$zip[idx], sid = st$sid[idx], dist = st$dist[idx],
    prev_zip = prev_zip[idx], prev_sid = prev_sid[idx],
    moved = move[idx],
    transferred = st$seen[idx] & !is.na(prev_sid[idx]) & st$sid[idx] != prev_sid[idx]
  )
  st$seen <- st$seen | act
}

panel <- bind_rows(recs) %>%
  mutate(research_id = st$research_id[i],
         race = st$race[i], male = st$male[i], frl = st$frl[i], immig = st$immig[i],
         ell = st$ell[i], iep = st$iep[i], iepcode = st$iepcode[i],
         ability = st$ability[i], absent = st$absent[i], region0 = st$region0[i],
         code_dist = schools$dist[sid], code_sch = schools$sch[sid],
         cni_sch = schools$cni[sid] == 1,
         nonres = code_dist %in% c(900310, 900320, 900330) & zip %in% zip_city,
         homeless = rbinom(n(), 1, 0.02 + 0.05 * frl + 0.05 * moved),
         flip = runif(n()) < 0.06,
         lunch = case_when(
           frl == 1 & !flip ~ sample(1:2, n(), TRUE, c(.8, .2)),
           frl == 0 &  flip ~ 1L,
           TRUE ~ 0L))

# ---- 7. Outcomes ------------------------------------------------------------
# Linear growth in grade + common year shocks keep parallel trends exact.
yr_ela  <- setNames(c(rnorm(9, 0, 0.8), -4, -2, -1), YEARS)  # 2021-23 COVID dip
yr_math <- setNames(c(rnorm(9, 0, 0.8), -6, -3, -2), YEARS)
yr_ela[as.character(2012:2020)]  <- round(yr_ela[as.character(2012:2020)], 2)
yr_math[as.character(2012:2020)] <- round(yr_math[as.character(2012:2020)], 2)

panel <- panel %>%
  mutate(
    treat_sch   = cni_sch & currentschoolyear >= POLICY_YR,
    treat_neigh = zip == CNI_ZIP & currentschoolyear >= POLICY_YR,
    ability_m   = 0.8 * ability + rnorm(n(), 0, 0.6),
    ela  = round(190 + 5 * (grade - 3) + 10 * ability - 3 * frl - 6 * ell - 8 * iep +
                   yr_ela[as.character(currentschoolyear)] +
                   EFFECT_SCHOOL * treat_sch + EFFECT_NEIGH * treat_neigh + rnorm(n(), 0, 5)),
    math = round(192 + 6 * (grade - 3) + 10 * ability_m - 3 * frl - 4 * ell - 8 * iep +
                   yr_math[as.character(currentschoolyear)] +
                   EFFECT_SCHOOL * treat_sch + EFFECT_NEIGH * treat_neigh + rnorm(n(), 0, 5)),
    covid_att = case_when(currentschoolyear == 2021 ~ -0.6,
                          currentschoolyear == 2022 ~ -0.5,
                          currentschoolyear == 2023 ~ -0.3, TRUE ~ 0),
    attend = plogis(2.7 + 0.4 * ability - 0.3 * frl - 0.5 * homeless +
                      0.5 * absent + covid_att + rnorm(n(), 0, 0.3)),
    gpa = case_when(
      grade < 6 ~ NA_real_,
      runif(n()) < 0.12 ~ 0,                           # 0 = not reported
      TRUE ~ round(pmin(4, pmax(0.5, 2.7 + 0.45 * ability - 0.25 * frl + rnorm(n(), 0, 0.35))), 2))
  )

# ---- 8. Messy raw records ---------------------------------------------------
messy_zip <- function(z) {
  u <- runif(length(z))
  out <- as.character(z)
  plus4 <- u < 0.15
  out[plus4] <- paste0(z[plus4], "-", sprintf("%04d", sample(1000:9999, sum(plus4), TRUE)))
  out[u >= 0.15 & u < 0.17] <- ""
  out
}

# Mid-year transfers: an earlier seq = 1 record at the old school/ZIP
early <- panel %>%
  filter(transferred, runif(n()) < 0.5) %>%
  mutate(seq = 1, zip = prev_zip, sid = prev_sid,
         code_dist = schools$dist[sid], code_sch = schools$sch[sid])
panel <- panel %>% mutate(seq = ifelse(paste(i, currentschoolyear) %in%
                                         paste(early$i, early$currentschoolyear), 2, 1))
rows_all <- bind_rows(panel, early) %>% arrange(research_id, currentschoolyear, seq)

# Numeric codes only; the value labels below document the codebook in README.md.
lab <- function(x, labels, label) as.numeric(x)
write_raw <- function(df, file) {
  write.csv(df, file.path(out_dir, file), row.names = FALSE, na = "")
}

core <- rows_all %>%
  transmute(
    research_id       = lab(research_id, NULL, "De-identified student ID"),
    currentschoolyear = lab(currentschoolyear, NULL, "School year (spring)"),
    seq               = lab(seq, NULL, "Record sequence within year (higher = later)"),
    reportingdistrictcode = lab(code_dist, NULL, "District code"),
    reportingschoolcode   = lab(code_sch,  NULL, "School code"),
    studentgradelevel = lab(grade, c(K = 0), "Grade level"),
    gender        = lab(ifelse(male == 1, 2, 1), c(Female = 1, Male = 2), "Gender"),
    raceethnicity = lab(race, c(Black = 1, White = 2, Hispanic = 3, Asian = 4,
                                Multiracial = 5), "Race/ethnicity"),
    zipcode       = messy_zip(zip),
    homeless      = lab(homeless, c(No = 0, Yes = 1), "Homeless"),
    lunchstatus   = lab(lunch, c(`Not eligible` = 0, Free = 1, Reduced = 2), "Lunch status"),
    immigrant     = lab(immig, c(No = 0, Yes = 1), "Immigrant"),
    lepell        = lab(ell, c(No = 0, Yes = 1), "English language learner"),
    residencystatus = lab(ifelse(nonres, 2, 1), c(Resident = 1,
                          `Non-resident (transfer program)` = 2), "Residency status"),
    iepdisability = lab(iepcode, c(None = 0, `Specific learning disability` = 1,
                        `Speech/language` = 2, `Other health impairment` = 3,
                        Autism = 4, `Emotional disturbance` = 5,
                        `Intellectual disability` = 6), "IEP primary disability"),
    spedplacement = lab(ifelse(iep == 1, sample(1:4, n(), TRUE, c(.6, .2, .15, .05)), NA),
                        c(`Regular class >= 80%` = 1, `Regular class 40-79%` = 2,
                          `Regular class < 40%` = 3, `Separate facility` = 4),
                        "Special education placement"),
    spedexit = ifelse(iep == 1 & runif(n()) < 0.03, sample(1:3, n(), TRUE), NA),
    gpa      = gpa,
    gpascale = ifelse(is.na(gpa), NA, 4)
  )

# Keep only the variables the analysis uses. The other columns are still
# simulated above so the random-number stream (and every value) is unchanged.
core <- core %>%
  select(research_id, currentschoolyear, seq, reportingdistrictcode, reportingschoolcode,
         studentgradelevel, gender, raceethnicity, zipcode, lunchstatus, lepell,
         iepdisability)

write_raw(core, "dese_student_core.csv")

# Enrollment: one row per school enrollment (two rows for mid-year movers)
enroll <- rows_all %>%
  filter(currentschoolyear >= 2013) %>%
  mutate(attend = ifelse(seq == 1, pmin(1, attend + rnorm(n(), 0, 0.03)), attend),
         daysenrolled = ifelse(seq == 1 | paste(i, currentschoolyear) %in%
                                 paste(early$i, early$currentschoolyear),
                               sample(40:130, n(), TRUE), sample(165:174, n(), TRUE))) %>%
  transmute(research_id, currentschoolyear,
            reportingdistrictcode = code_dist, reportingschoolcode = code_sch,
            daysenrolled,
            attendancerate = round(attend, 3))
write_raw(enroll, "dese_student_enroll.csv")

# Discipline: long, one row per removal incident
disc <- panel %>%
  filter(currentschoolyear >= 2013, grade >= 1) %>%
  mutate(n_inc = rpois(n(), exp(-2.8 + 0.8 * (grade %in% 6:9) + 0.5 * frl -
                                  0.3 * ability + 0.3 * male))) %>%
  filter(n_inc > 0) %>%
  uncount(n_inc) %>%
  mutate(type = sample(1:4, n(), TRUE, c(.55, .40, .04, .01)),
         days = case_when(type == 1 ~ sample(1:3, n(), TRUE),
                          type == 2 ~ sample(1:10, n(), TRUE),
                          type == 3 ~ sample(1:5, n(), TRUE),
                          TRUE ~ 180L),
         days = ifelse(runif(n()) < 0.03, NA, days)) %>%
  transmute(research_id, currentschoolyear,
            disciplineremoval = lab(type, c(ISS = 1, OSS = 2, UR = 3, EXP = 4),
                                    "Removal type"),
            lengthremoved = days)
write_raw(disc, "dese_student_discipline.csv")

# Tests: MAP grades 3-8, none in 2020; some scores carry a +2000 code
code2000 <- function(x) ifelse(!is.na(x) & runif(length(x)) < 0.04, x + 2000, x)
test <- panel %>%
  filter(currentschoolyear >= 2013, currentschoolyear != 2020, grade %in% 3:8,
         runif(n()) < 0.90) %>%
  mutate(ela  = ifelse(runif(n()) < 0.03, NA, ela),
         math = ifelse(runif(n()) < 0.03, NA, math)) %>%
  filter(!(is.na(ela) & is.na(math))) %>%
  transmute(research_id, currentschoolyear,
            studentgradelevel = grade,
            map_score1 = lab(code2000(ela),  NULL, "MAP ELA scale score"),
            map_score2 = lab(code2000(math), NULL, "MAP Math scale score"))
write_raw(test, "dese_student_test.csv")

# ---- 9. School files --------------------------------------------------------
building_list <- schools %>%
  left_join(districts, by = "dist") %>%
  transmute(
    CTYDIST  = as.character(dist),
    DISTNAME = distname,
    SCHNUM   = sprintf("%04d", sch),
    SCHNAME  = schname,
    SCHADDR1 = paste(sample(100:9800, n()), sample(c("Sample St", "Example Ave",
               "Placeholder Blvd", "Mock Rd", "Demo Dr"), n(), TRUE)),
    SCHCITY  = case_when(zip %/% 1000 == 64 ~ "Kansas City",
                         zip %in% c(65201, 65203) ~ "Columbia",
                         zip %/% 1000 == 65 ~ "Springfield",
                         TRUE ~ "St. Louis"),
    SCHZIP   = ifelse(runif(n()) < 0.3,
                      paste0(zip, "-", sample(1000:9999, n(), TRUE)), as.character(zip)),
    `ELEM SCHOOL`    = ifelse(level %in% c("elem", "k8"), "Y", "N"),
    `MIDDLE SCHOOL`  = ifelse(level %in% c("middle", "k8"), "Y", "N"),
    `JR HIGH SCHOOL` = "N",
    `HIGH SCHOOL`    = ifelse(level == "high", "Y", "N")
  )
building_list <- building_list %>%
  select(CTYDIST, DISTNAME, SCHNUM, SCHNAME, SCHZIP,
         `ELEM SCHOOL`, `MIDDLE SCHOOL`, `HIGH SCHOOL`)
write_raw(building_list, "building_list.csv")

# School-year demographics: the simulated sample scaled up to building size
school_demo <- panel %>%
  count(code_dist, code_sch, currentschoolyear, race, frl) %>%
  group_by(code_dist, code_sch) %>%
  mutate(scale = runif(1, 3.5, 5.5)) %>%
  group_by(code_dist, code_sch, currentschoolyear) %>%
  summarise(enroll_demo     = round(sum(n) * first(scale)),
            enroll_white    = round(sum(n[race == 2]) * first(scale)),
            enroll_black    = round(sum(n[race == 1]) * first(scale)),
            enroll_hispanic = round(sum(n[race == 3]) * first(scale)),
            enroll_asian    = round(sum(n[race == 4]) * first(scale)),
            enroll_frl      = round(sum(n[frl == 1]) * first(scale)),
            .groups = "drop") %>%
  rename(reportingdistrictcode = code_dist, reportingschoolcode = code_sch) %>%
  select(reportingdistrictcode, reportingschoolcode, currentschoolyear,
         enroll_demo, enroll_black, enroll_frl)
write_raw(school_demo, "dese_school_demo.csv")

# ---- 10. Mock ACS ZIP panel (stands in for a tidycensus pull) -------------
# Generated directly at the ZIP level, so its precision does not depend on the
# number of simulated students. Baseline levels follow each ZIP's simulated
# student composition; the CNI neighborhood changes from 2019 on.
ACS_YEARS <- 2014:2023
acs_base <- panel %>%
  filter(zip %in% c(zip_city, zip_county), currentschoolyear < POLICY_YR) %>%
  group_by(zip) %>%
  summarise(base_black = mean(race == 1), base_frl = mean(frl), .groups = "drop") %>%
  mutate(base_black = pmin(0.95, pmax(0.03, 0.5 * base_black +
                                         0.5 * ifelse(zip %in% zip_city, 0.65, 0.28))),
         base_black = ifelse(zip == CNI_ZIP, 0.70, base_black),   # inside the donor range
         pop0  = round(runif(n(), 8000, 40000)),
         inc0  = round(90000 - 55000 * base_frl + rnorm(n(), 0, 5000)),
         trend_black = rnorm(n(), 0, 0.003))                       # ZIP-specific drift

acs <- acs_base %>%
  crossing(year = ACS_YEARS) %>%
  mutate(
    t_post = pmax(0, year - (POLICY_YR - 1)) * (zip == CNI_ZIP),   # 0 before 2019; 1, 2, ... after
    pop_total     = round(pop0 * (1 + 0.004 * (year - 2014)) * (1 + 0.10 * t_post) *
                            (1 + rnorm(n(), 0, 0.01))),
    pct_black     = round(pmin(0.99, base_black + trend_black * (year - 2014) +
                                 0.035 * t_post + rnorm(n(), 0, 0.006)), 3),
    median_income = round(inc0 * 1.025^(year - 2014) * (1 - 0.04 * t_post) *
                            (1 + rnorm(n(), 0, 0.015)))
  ) %>%
  select(zip, year, median_income, pct_black, pop_total)
write_raw(acs, "acs_zip_panel_mock.csv")

# ---- 11. Summary ------------------------------------------------------------
cat("Wrote", length(list.files(out_dir)), "files to", out_dir, "\n")
cat("Core rows:", nrow(core), "| students:", n_distinct(core$research_id),
    "| enroll:", nrow(enroll), "| discipline:", nrow(disc),
    "| test:", nrow(test), "| schools:", nrow(building_list), "\n")
cat("CNI schools (dist-sch):", with(schools[schools$cni == 1, ], paste(dist, sch, sep = "-")), "\n")
cat("Planted effects (MAP points, year >= ", POLICY_YR, "): CNI school +",
    EFFECT_SCHOOL, ", ZIP ", CNI_ZIP, " +", EFFECT_NEIGH, "\n", sep = "")
