global own "C:\Users\annieshrestha/Downloads/WIL\Documents\Data cleaning Sub Saharan Africa\WIL Minigrant - data cleaning with Annie\"
global data "$own/Raw Data/"
global graphs "$own/Graphs/"

use "/Users/annieshrestha/Downloads/WIL/Time Use/Raw data/South Africa/Time Use/2000/tus-2000-diary-v1.dta", replace

*sex: Q116Gender
*age: Q117Age
*marital status: Q23MaritalStatus
*marketable work : Activ 1-3
*domestic work: activ4
*care work: activ5-6
*weight = perwgt dans db tus-2000-person-v1
*here, there can be many activities at once: will focus on the primary one first (also doing an index for multitasking)

*three columns for primary, secondary, tertiary activity
destring atimeper, gen(activ1) 
destring btimeper, gen(activ2) force
destring ctimeper, gen(activ3) force

*i've found the 10 categories in the code and i'm generating other variables to get an activity-level view
forval v= 1/3{
gen emp_establishment`v' = floor(activ`v'/100 )==1 
gen emp_prod_nonest`v' = floor(activ`v'/100)==2 
gen emp_serv_nonest`v' = floor(activ`v'/100)==3
gen dom_work`v' = floor(activ`v'/100)==4 
gen care_work`v' = floor(activ`v'/100)==5 
gen community_serv`v' = floor(activ`v'/100)==6 
gen learning`v' = floor(activ`v'/100)==7 
gen social`v' = floor(activ`v'/100)==8
gen media`v' = floor(activ`v'/100)==9 
gen selfcare`v'= floor(activ`v'/100)==0 
}

*alternatively, this is just a simplification (10 categories instead of 999) from the first format
forval v = 1/3 {
    gen categ`v' = .
    replace categ`v' = 1 if emp_establishment`v' == 1
    replace categ`v' = 2 if emp_prod_nonest`v' == 1
    replace categ`v' = 3 if emp_serv_nonest`v' == 1
    replace categ`v' = 4 if dom_work`v' == 1
    replace categ`v' = 5 if care_work`v' == 1
    replace categ`v' = 6 if community_serv`v' == 1
    replace categ`v' = 7 if learning`v' == 1
    replace categ`v' = 8 if social`v' == 1
    replace categ`v' = 9 if media`v' == 1
    replace categ`v' = 10 if selfcare`v' == 1
}

label define categ_label 1 "Employment in establishment" 2 "Non-establishment production work" 3 "Non-establishment service work"  4 "Domestic work" /* 
*/   5 "Care work" 6 "Community service"  7 "Learning"  8 "Social activities" 9 "Media/Entertainment"  10 "Self-care", modify

// Apply the value labels to each categ variable
forval v = 1/3 {
    label values categ`v' categ_label
}

*saving this data so that we can then merge it back when we will have linked spouses
preserve 
keep uqnr person activ1 timeslot
tempfile time_detailed
save `time_detailed'
restore 

/*this is a way to manage simultaneity if we ever want to do visuals on the total time during the day spent doing smth, rather than the timetables
gen time1 = 30 
gen time2 = 30 if cat2 !=. 
replace time2 =0 if time2==. 
gen time3 = 30 if cat3 !=. 
replace time3=0 if time3==. 


gen nb_actis =  1

replace nb_actis = 2 if btimeper!="@@@" 
replace nb_actis = 3 if ctimeper!="@@@" 

replace time1 = 15 if nb_actis == 2 & asametim != bsametim 
replace time2 = 15 if nb_actis == 2 & asametim != bsametim 
*simultaneity is when asametime = bsametime (=csametim if 3 actis)
replace time1 = 10 if nb_actis ==3 & asametim != bsametim | nb_actis ==3 &  asametim != csametim | nb_actis ==3 &csametim != bsametim 
replace time2 = 10 if nb_actis ==3 & asametim != bsametim | nb_actis ==3 &   asametim != csametim | nb_actis ==3 & csametim != bsametim 
replace time3 = 10 if nb_actis ==3 & asametim != bsametim | nb_actis ==3 & asametim != csametim | nb_actis ==3 & csametim != bsametim 

gen simultaneity = asametim == bsametim & nb_actis==2 | asametim == bsametim & bsametim == csametim & nb_actis ==3
*/

bysort uqnr person: gen s=_N
drop if s!=48

preserve 
keep uqnr person timeslot categ*
tempfile time_obs
save `time_obs'
restore

keep uqnr person  
duplicates drop 

*getting socio-demographic variables from the other dataset 
preserve 
tempfile 1 
use "/Users/annieshrestha/Downloads/WIL/Time Use/Raw data/South Africa/Time Use/2000/tus-2000-person-v1.dta", clear 
gen has_nf_business = business=="1" 
gen has_f_business  = farming=="1" | fishing=="1" 
gen helps_unpaid    = unpaid =="1" 
gen has_wage_job    = domestic=="1" | anyworkp=="1"
bysort uqnr person: gen s=_N
drop if s>1
save `1'
restore 

merge 1:1 uqnr person using `1', keepusing( has* helps* age gender perwgt mar1tals edate status child18h child06h has* helps*)
drop if _merge!=3

*reshaping to get a single row per couple: couple localisation
destring gender, gen(sex)
rename age Q117Age
drop if Q117Age=="**"
destring Q117Age, replace
gen age =. 
replace age = 1 if Q117Age<15 & Q117Age!=.
replace age = 2 if Q117Age>14 & Q117Age<65 & Q117Age!=. 
replace age = 3 if Q117Age>64 & Q117Age!=. 
label define age 1 "below working age" 2 "working age" 3 "above working age", modify
label values age age
gen self_emp = status=="3" | status=="4" 
gen wage_emp = status=="1" | status=="2"

*keeping only people we think are in couple = 2 different-sex ppl that are married with age difference<20 yrs 
gen married = mar1tals == "2"
bysort uqnr: egen married_couple = total(married==1)
bysort uqnr: gen n=_N
tab n
drop if n!=2
bysort uqnr: egen bothgenders = total (sex==1)
tab bothgenders
drop if bothgenders!=1 
bysort uqnr: egen major = total(Q117Age>=18)
drop if major!=2
bysort uqnr : egen max = max(Q117Age)
bysort uqnr : egen min = min(Q117Age)
gen age_dif = max - min
keep if age_dif <=20 
keep uqnr* has* helps* sex* self_emp person  perwgt  wage_emp  Q117Age child18h child06h

*Actual reshaping : 
reshape wide  has* helps* self_emp wage_emp person  perwgt Q117Age child18h child06h, i(uqnr) j(sex)

rename person2 person 
 
*merging back into the half-hour level dataset and reshaping - detailed version
preserve 

merge 1:m uqnr person using `time_detailed'
keep if _merge==3 
drop _merge
gen has_business1 = has_nf_business1 | has_f_business1 
tab has_business1
label define self_emp1 0 "husband not SE" 1 "husband SE"
label values self_emp1 self_emp1
label values has_business1 self_emp1

gen wage_wife= has_wage_job2 == 1| helps_unpaid2==1 
gen test=1 

collapse (count) test [pw=perwgt2], by(wage_wife has_business1 timeslot activ1)
gsort timeslot wage_wife has_business1 - test
bysort timeslot wage_wife has_business1: keep if _n==1 
egen id = concat(wage_wife has_business1)
keep id timeslot activ1 
reshape wide activ1, i(id) j(timeslot) string
gen idd = "No business husb no wage wife" if id=="00" 
replace idd = "No business husband wage wife" if id=="10"
replace idd = "Business husband no wage wife" if id=="01"
replace idd = "Business husband wage wife" if id=="11"
label values activ* categ_label

mkmat activ*, matrix(activ) rownames(idd) 
matrix colnames activ = "4h00" "4h30" "5h00" "5h30" "6h00" "6h30" "7h00" "7h30" "8h00" "8h30" "9h00" "9h30" "10h00" "10h30" "11h00" "11h30" "12h00" "12h30" "13h00" "13h30" "14h00" "14h30" "15h00" "15h30" "16h00" "16h30" "17h00" "17h30" "18h00" "18h30" "19h00" "19h30" "20h00" "20h30" "21h00" "21h30" "22h00" "22h30" "23h00" "23h30" "0h00" "0h30" "1h00" "1h30" "2h00" "2h30" "3h00" "3h30"
plotmatrix, split(0(1)1000) color(sienna maroon brown orange_red orange yellow gold navy blue) title("what are women doing?!?")   mat(activ) ylabel(, labsize(vsmall)) ylabel(,angle(40)) xlab(, labsize(vsmall))  legend(size(vsmall)) note("Head of hh or women married to head of hh only. Activity is the occupation with ""the highest count of women doing it for this half-hour and category.")  legend(order(1 "010: Sleep" 2 "020: Eating and drinking" 3 "050: Doing nothing" 4 "111: Wage labour" 5 "180: Travel to/from work etc" 6 "410: Cooking" 7 "420: Cleaning" 8 "831: Socialising with family" 9 "920: Watching television and video")) legend(pos(6))
graph export "$graphs\detailed_timetableacrossbizwage_SA2000.png", replace
restore 



*reshape - not detailed version 
merge 1:m uqnr person using `time_obs'
keep if _merge==3 
drop _merge
gen has_business1 = has_nf_business1 | has_f_business1 
tab has_business1
label define self_emp1 0 "husband not SE" 1 "husband SE"
label values self_emp1 self_emp1
label values has_business1 self_emp1

gen wage_wife= has_wage_job2 == 1| helps_unpaid2==1 
gen test=1 

preserve 
collapse (count) test [pw=perwgt2], by(wage_wife has_business1 timeslot categ1)
gsort timeslot wage_wife has_business1 - test
bysort timeslot wage_wife has_business1: keep if _n==1 
rename categ1 winner1 
egen id = concat(wage_wife has_business1)
keep id timeslot winner1 
reshape wide winner1, i(id) j(timeslot) string
tempfile winner1 
save `winner1'
gen idd = "No business husb no wage wife" if id=="00" 
replace idd = "No business husband wage wife" if id=="10"
replace idd = "Business husband no wage wife" if id=="01"
replace idd = "Business husband wage wife" if id=="11"
label values winner* categ_label

mkmat winner*, matrix(winner) rownames(idd) 
matrix colnames winner = "4h00" "4h30" "5h00" "5h30" "6h00" "6h30" "7h00" "7h30" "8h00" "8h30" "9h00" "9h30" "10h00" "10h30" "11h00" "11h30" "12h00" "12h30" "13h00" "13h30" "14h00" "14h30" "15h00" "15h30" "16h00" "16h30" "17h00" "17h30" "18h00" "18h30" "19h00" "19h30" "20h00" "20h30" "21h00" "21h30" "22h00" "22h30" "23h00" "23h30" "0h00" "0h30" "1h00" "1h30" "2h00" "2h30" "3h00" "3h30"
plotmatrix, title("what are women doing?!?")  color(orange_red gold  maroon brown sienna)  mat(winner) s(0(1)10) ylabel(, labsize(vsmall)) ylabel(,angle(40)) xlab(, labsize(vsmall)) legend(order(1 "Employment in establishment" 2 "Domestic work" 3 "Social" 4 "Media" 5 "Sleep")) legend(size(vsmall)) note("Head of hh or women married to head of hh only. Activity is the occupation with ""the highest count of women doing it for this half-hour and category.")
graph export "$graphs\timetableacrossbizwage_SA2000.png", replace

*restore
