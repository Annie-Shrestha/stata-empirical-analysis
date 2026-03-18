** Author: Annie Shrestha **
** Adapted from: Annie Shrestha 2012 code **

global root "/Users/annieshrestha/Downloads/WIL/"
global data "$root/WIL Minigrant/Raw data"
global wd "$root/WIL Minigrant/Working Data"
global graph "$root/WIL Minigrant/Graphs"

************
** HH info **
************

use "$data/2010/data/hhold/muc1a.dta", clear

egen hhid10 = concat(tinh huyen diaban xa hoso),punct(-)
bysort hhid10 : gen hhsize=_N

keep if m1ac3 == 1 | m1ac3==2
egen ivid10 = concat(hhid10 matv), punct(-)

rename m1ac3 role_hh 
rename m1ac5 age 

gen sex     = "woman" if m1ac2==2
replace sex = "man"   if m1ac2==1 
keep hhid10 role_hh sex ivid10 tinh age hhsize 
bysort hhid10: egen total  = total(sex=="man")
bysort hhid10: egen total2 = total(sex=="woman")
drop if total>1 | total2>1
tempfile hh10
save `hh10', replace

use "$data/2010/data/hhold/ho11.dta", clear
egen hhid10 = concat(tinh huyen diaban xa hoso),punct(-)
gen urban = ttnt==1
keep hhid urban
duplicates drop 
merge 1:m hhid10 using "`hh10'"
drop if _m !=3
drop _m 
save `hh10', replace

*********************
**HH info continued**
*********************

use "$data/2010/data/hhold/muc2a1.dta", clear
egen hhid10 = concat(tinh huyen diaban xa hoso),punct(-)
egen ivid10 = concat(hhid10 matv), punct(-)
gen educ = m2ac2a > 1 & m2ac2a !=.
keep hhid ivid educ
label variable educ "more than maternelle"

merge 1:1 ivid using `hh10'
drop if _m!=3 
drop _m

save `hh10', replace 


********************
**General job info**
********************

** First merge 4a1, 4a2, 4a3, 4a4, and 4a5 using the common columns in a file 4a to meet the data structure of 2012.

use "$data/2010/data/hhold/muc4a1.dta", clear
isid tinh huyen xa diaban hoso matv

local base "$data/2010/data/hhold"
foreach p in a2 a3 a4 a5 {
    local f "`base'/muc4`p'.dta"
    confirm file "`f'"          
    merge 1:1 tinh huyen xa diaban hoso matv using "`f'", nogen assert(1 3)
}
tempfile muc4A
save `muc4A', replace

use `muc4A', clear
egen hhid10 = concat(tinh huyen diaban xa hoso),punct(-)
egen ivid10 = concat(hhid10 matv), punct(-)
egen wid10 = concat(tinh huyen diaban xa),punct(-)

gen work_wage_year      = m4ac1a==1
gen work_SEfarm_year    = m4ac1b==1 
gen work_SEnf_year      = m4ac1c==1 
gen work_status         = m4ac8a
gen work_mj_SEown       = work_status==1 | work_status==2
gen work_mj_wage        = work_mj_SEown==0 & work_status!=.
gen work_mj_SEnf        = work_status==2
gen work_mj_SEf         = work_status==1
gen work_dpy            = m4ac3a
gen work_hpd            = m4ac7 
gen work_mjy_isic       = m4ac4
gen work_mj_formal_wage = (m4ac13c==1) & work_mj_wage==1

gen work_2nd_wage       = m4ac20==1 | m4ac20 ==2 
gen work_2nd_SEown      = work_2nd_wage==0 & m4ac20 !=. 
gen work_2nd_SEnf       = m4ac20 ==2
gen work_2nd_SEf        = m4ac20 ==1 
gen work_2nd_formalwage = m4ac24b !=0 & work_2nd_wage==1 
gen work_2nd_dpy        = m4ac15
gen work_2nd_hpd        = m4ac19

gen work_dpy_wage       = m4ac3a 
replace work_dpy_wage   = 0 if work_mj_wage==0  
replace work_dpy_wage   = work_2nd_dpy if work_2nd_wage==1 & work_mj_wage==0 
replace work_dpy_wage   = work_2nd_dpy + work_dpy if work_2nd_wage==1 & work_mj_wage==1 

gen work_hpy   = work_hpd*work_dpy
gen work_2nd_hpy = work_2nd_hpd*work_2nd_dpy

gen hours_firm1 = work_hpy       if work_mj_SEnf==1 
gen hours_firm2 = work_2nd_hpy   if work_2nd_SEnf==1 
forval i=1/2{
	replace hours_firm`i' =0 if hours_firm`i' ==. 
}
egen work_hrs_nf = rowtotal(hours_firm*)
gen  work_log_hrs_nf = log(work_hrs_nf)

gen hours_farm1 = work_hpy     if work_mj_SEf==1 
gen hours_farm2 = work_2nd_hpy if work_2nd_SEf==1 
forval i=1/2{
	replace hours_farm`i' =0 if hours_farm`i' ==. 
}
egen work_hrs_f = rowtotal(hours_farm*)
gen  work_log_hrs_f = log(work_hrs_f)

egen work_total_dpy = rowtotal(work_*dpy)
gen wage_wage = m4ac11 if work_mj_wage==1 
gen wage_ind  = m4ac4c if work_mj_wage==1

keep *id* work*  *wage*

merge 1:1 ivid using `hh10'
drop if _m!=3 
drop _m

save `hh10', replace
use "$data/2010/data/hhold/muc3a.dta", clear
egen hhid10 = concat(tinh huyen diaban xa hoso),punct(-)
egen ivid10 = concat(hhid10 matv), punct(-)
egen wid10 = concat(tinh huyen diaban xa),punct(-)

gen sick_nbvisitsd = m3c5a + m3c6a
bysort ivid: egen sick_nbvisits = total(sick_nbvisitsd)
drop sick*d
keep ivid sick
duplicates drop 
merge 1:1 ivid using `hh10'
drop if _m ==1
replace sick_nbvisits = 0 if _m==2
drop _m


reshape wide work* wage* sick ivid10 educ role_hh age, i(hhid10) j(sex) string
gen childbearingagewoman = agewoman<40 & agewoman!=.
gen preshock_mannffirm = work_SEnf_yearman==1 
gen preshock_manfarm = work_SEfarm_yearman==1
gen preshock_manown_famfirm = (work_SEfarm_yearman==1 | work_SEnf_yearman==1)
gen formal_woman_preshock = (work_mj_formal_wagewoman==1 | work_2nd_formalwagewoman==1)
gen wage_woman_preshock   = (work_mj_wagewoman==1 | work_2nd_wagewoman==1)
gen wage_woman_mj_preshock = work_mj_wagewoman==1 
gen formal_woman_mj_preshock = work_mj_formal_wagewoman==1
save `hh10', replace 


use "$data/2010/data/hhold/weight10.dta", clear
egen wid10 = concat(tinh huyen diaban xa),punct(-)
keep wid wt9

merge 1:m wid using `hh10'
drop if _m!=3 
drop _m

save "$wd\2010_hh_spouses.dta", replace




