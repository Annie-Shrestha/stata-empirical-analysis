global root   "/Users/annieshrestha/Downloads/WIL/Time Use/Raw data/South Africa/Time Use/2010"
global data   "$root"
global graphs "$root/Graphs"
cap mkdir "$graphs"

local YES = 1


* A) Activities file

use "$data/tus-2010-activities-v1.2.dta", clear

keep UQNO PERSONNO Timeslot Act Activity_code
isid UQNO PERSONNO Timeslot Act

reshape wide Activity_code, i(UQNO PERSONNO Timeslot) j(Act)

rename Activity_code1 activ1
rename Activity_code2 activ2
rename Activity_code3 activ3

* keep only complete diaries (48 half-hour slots per person)
bysort UQNO PERSONNO: gen s = _N
drop if s != 48
drop s

* build 10 broad categories from detailed activity code
forval v=1/3 {
    gen categ`v' = .
    replace categ`v' = 1  if !missing(activ`v') & floor(activ`v'/100)==1
    replace categ`v' = 2  if !missing(activ`v') & floor(activ`v'/100)==2
    replace categ`v' = 3  if !missing(activ`v') & floor(activ`v'/100)==3
    replace categ`v' = 4  if !missing(activ`v') & floor(activ`v'/100)==4
    replace categ`v' = 5  if !missing(activ`v') & floor(activ`v'/100)==5
    replace categ`v' = 6  if !missing(activ`v') & floor(activ`v'/100)==6
    replace categ`v' = 7  if !missing(activ`v') & floor(activ`v'/100)==7
    replace categ`v' = 8  if !missing(activ`v') & floor(activ`v'/100)==8
    replace categ`v' = 9  if !missing(activ`v') & floor(activ`v'/100)==9
    replace categ`v' = 10 if !missing(activ`v') & floor(activ`v'/100)==0
}

label define categ_label ///
    1  "Employment in establishment" ///
    2  "Non-establishment production work" ///
    3  "Non-establishment service work" ///
    4  "Domestic work" ///
    5  "Care work" ///
    6  "Community service" ///
    7  "Learning" ///
    8  "Social activities" ///
    9  "Media/Entertainment" ///
    10 "Self-care", modify
forval v=1/3 {
    label values categ`v' categ_label
}

preserve
    keep UQNO PERSONNO Timeslot activ1
    tempfile time_detailed_2010
    save `time_detailed_2010', replace
restore

preserve
    keep UQNO PERSONNO Timeslot categ*
    tempfile time_obs_2010
    save `time_obs_2010', replace
restore

keep UQNO PERSONNO
duplicates drop
tempfile diary_shell
save `diary_shell', replace


* B) PERSON FILE
use "$data/tus-2010-person-v1.2.dta", clear

* one row per person
bysort UQNO PERSONNO: gen s=_N
drop if s>1
drop s

* keep only diary persons
merge 1:1 UQNO PERSONNO using `diary_shell'
keep if _merge==3
drop _merge

gen sex = Q116Gender
replace Q117Age = . if Q117Age<0 | Q117Age>=998

gen has_nf_business = (Q31OwnBusns == `YES') if !missing(Q31OwnBusns)
gen has_f_business  = (Q47aFarmwrk_W == `YES') if !missing(Q47aFarmwrk_W)
gen helps_unpaid    = (Q31UnPdWrk == `YES') if !missing(Q31UnPdWrk)
gen has_wage_job    = (Q31PdWrk   == `YES') if !missing(Q31PdWrk)

gen self_emp = (Q31OwnBusns == `YES' | Q47aFarmwrk_W == `YES') if !missing(Q31OwnBusns) | !missing(Q47aFarmwrk_W)
gen wage_emp = (Q31PdWrk   == `YES') if !missing(Q31PdWrk)

* Couple selection filters

* (1) exactly 2 diary persons per household
bysort UQNO: gen n=_N
drop if n!=2
drop n

* (2) one male and one female (assumes 1=male 2=female)
bysort UQNO: egen n_male = total(sex==1)
bysort UQNO: egen n_fem  = total(sex==2)
drop if n_male!=1 | n_fem!=1
drop n_male n_fem

* (3) both adults
bysort UQNO: egen major = total(Q117Age>=18) if !missing(Q117Age)
drop if major!=2
drop major

* (4) both married/living together
gen married = inlist(Q23MaritalStatus, 1, 2) if !missing(Q23MaritalStatus)
bysort UQNO: egen nmar = total(married==1)
drop if nmar!=2
drop nmar married

* (5) age difference <= 20
bysort UQNO: egen maxage = max(Q117Age)
bysort UQNO: egen minage = min(Q117Age)
gen age_dif = maxage - minage
keep if age_dif<=20
drop maxage minage age_dif

* Keep needed vars and reshape to 1 row per couple 
keep UQNO PERSONNO sex Weight Q117Age Q27Child18HH Q29Child06HH ///
     has_nf_business has_f_business has_wage_job helps_unpaid ///
     self_emp wage_emp

reshape wide has_nf_business has_f_business has_wage_job helps_unpaid self_emp wage_emp ///
             PERSONNO Weight Q117Age Q27Child18HH Q29Child06HH, ///
       i(UQNO) j(sex)
	   

*renaming variables like in SA2000
preserve
    rename UQNO uqnr

    * IDs + weights
    rename PERSONNO1 person1
    rename PERSONNO2 person
    rename Weight1   perwgt1
    rename Weight2   perwgt2

    * kids variables
    rename Q27Child18HH1 child18h1
    rename Q29Child06HH1 child06h1
    rename Q27Child18HH2 child18h2
    rename Q29Child06HH2 child06h2

    keep uqnr ///
         has_nf_business1 has_f_business1 has_wage_job1 helps_unpaid1 self_emp1 wage_emp1 ///
         person1 perwgt1 Q117Age1 child18h1 child06h1 ///
         has_nf_business2 has_f_business2 has_wage_job2 helps_unpaid2 self_emp2 wage_emp2 ///
         person  perwgt2 Q117Age2 child18h2 child06h2

    save "$graphs/couples2010.dta", replace
restore

rename PERSONNO2 PERSONNO
rename Weight2 Weight_wife
rename Weight1 Weight_husb
tempfile couples2010
save `couples2010', replace

* C) NOT DETAILED TIMETABLE (winner broad category per slot)  
use `couples2010', clear
merge 1:m UQNO PERSONNO using `time_obs_2010'
keep if _merge==3
drop _merge

gen has_business1 = (has_nf_business1==1 | has_f_business1==1)
gen wage_wife     = (has_wage_job2==1 | helps_unpaid2==1)

gen test=1
collapse (count) test [pw=Weight_wife], by(wage_wife has_business1 Timeslot categ1)
gsort Timeslot wage_wife has_business1 -test
bysort Timeslot wage_wife has_business1: keep if _n==1

rename categ1 winner1
egen id = concat(wage_wife has_business1)
keep id Timeslot winner1
reshape wide winner1, i(id) j(Timeslot)

label values winner* categ_label
mkmat winner*, matrix(winner)

plotmatrix, ///
    split(0(1)10) ///
    color(orange_red gold maroon brown sienna ///
          navy blue yellow orange) ///
    title("SA 2010: what are women doing?!?") ///
    mat(winner) ///
    ylabel(, labsize(vsmall) angle(40)) ///
    xlab(, labsize(vsmall)) ///
    legend(size(vsmall)) ///
    legend(order(1 "Employment in establishment" ///
                 2 "Non-establishment production work" ///
                 3 "Non-establishment service work" ///
                 4 "Domestic work" ///
                 5 "Care work" ///
                 6 "Community service" ///
                 7 "Learning" ///
                 8 "Social activities" ///
                 9 "Media / Entertainment" ///
                 10 "Self-care")) ///
    legend(pos(6))


graph export "$graphs/timetableacrossbizwage_SA2010.png", replace

* D) DETAILED TIMETABLE
use `couples2010', clear
merge 1:m UQNO PERSONNO using `time_detailed_2010'
keep if _merge==3
drop _merge

gen has_business1 = (has_nf_business1==1 | has_f_business1==1)
gen wage_wife     = (has_wage_job2==1 | helps_unpaid2==1)

gen test=1
collapse (count) test [pw=Weight_wife], by(wage_wife has_business1 Timeslot activ1)
gsort Timeslot wage_wife has_business1 -test
bysort Timeslot wage_wife has_business1: keep if _n==1

egen id = concat(wage_wife has_business1)
keep id Timeslot activ1
reshape wide activ1, i(id) j(Timeslot)

mkmat activ*, matrix(activ)

plotmatrix, ///
    split(0(1)1000) ///
    color(sienna maroon brown orange_red orange ///
          yellow gold navy blue) ///
    title("SA 2010: what are women doing?!? (detailed)") ///
    mat(activ) ///
    ylabel(, labsize(vsmall) angle(40)) ///
    xlab(, labsize(vsmall)) ///
    legend(size(vsmall)) ///
    legend(order(1 "010: Sleep" ///
                 2 "020: Eating and drinking" ///
                 3 "050: Doing nothing" ///
                 4 "111: Wage labour" ///
                 5 "180: Travel to/from work etc" ///
                 6 "410: Cooking" ///
                 7 "420: Cleaning" ///
                 8 "831: Socialising with family" ///
                 9 "920: Watching television and video")) ///
    legend(pos(6))


graph export "$graphs/detailed_timetableacrossbizwage_SA2010.png", replace
use "$graphs/couples2010.dta", clear
describe
count
browse
