global own "/Users/annieshrestha/Downloads/WIL/Time Use/Raw data/Vietnam/Time Use/"
global data "$own"
global graphs "$own/Graphs/"
capture mkdir "$graphs"

use "$data/3_individual_id_main.dta", clear

gen emp_status = .
replace emp_status = 0 if Q304_1 == 0
replace emp_status = 1 if Q304_1 == 1
replace emp_status = 2 if Q304_1 == 2
replace emp_status = 3 if Q304_1 == 3

label define emp_status_lbl 0 "Not working" 1 "Wage work" 2 "Farm work" 3 "Non-farm business", modify
label values emp_status emp_status_lbl

gen has_farm_biz = (Q304_1 == 2 | Q304_1 == 3) if Q304_1 != .
gen has_wage = (Q304_1 == 1) if Q304_1 != .
replace has_wage = 1 if Q307 == 1

label define yesno 0 "No" 1 "Yes", modify
label values has_farm_biz has_wage yesno

keep ID pid weight Q304_1 Q307 emp_status has_farm_biz has_wage region3 agegroup

tempfile individual
save `individual'

use "$data/4_diary_main.dta", clear

gen categ = .
replace categ = 1  if Q401 >= 101 & Q401 <= 199
replace categ = 2  if Q401 >= 201 & Q401 <= 499
replace categ = 3  if Q401 >= 501 & Q401 <= 599
replace categ = 4  if Q401 >= 601 & Q401 <= 699
replace categ = 5  if Q401 >= 701 & Q401 <= 799
replace categ = 6  if Q401 >= 801 & Q401 <= 899
replace categ = 7  if Q401 >= 901 & Q401 <= 999
replace categ = 8  if (Q401 >= 1001 & Q401 <= 1199) | (Q401 >= 1301 & Q401 <= 1399)
replace categ = 9  if (Q401 >= 1201 & Q401 <= 1299) | (Q401 >= 1401 & Q401 <= 1499)
replace categ = 10 if Q401 >= 1501 & Q401 <= 1599
replace categ = 99 if Q401 >= 9998

label define categ_label 1 "Formal employment" 2 "Non-estab production" 3 "Non-estab services" ///
    4 "Domestic work" 5 "Care work" 6 "Community service" 7 "Learning" ///
    8 "Social/Leisure" 9 "Media/Entertainment" 10 "Self-care" 99 "Unspecified", modify
label values categ categ_label

merge m:1 ID pid using `individual'
keep if _merge == 3
drop _merge

keep if gender == 2

preserve
keep ID pid Q401 categ BEGIN END Duration gender weight emp_status has_farm_biz has_wage SEQ
tempfile episodes
save `episodes'
restore

use `episodes', clear

expand 48
bysort ID pid SEQ: gen slot = _n

gen slot_start = 240 + (slot - 1) * 30
gen slot_end = slot_start + 29

keep if BEGIN <= slot_end & END > slot_start

gen time_in_slot = min(END, slot_end + 1) - max(BEGIN, slot_start)
replace time_in_slot = 0 if time_in_slot < 0

bysort ID pid slot: egen max_time = max(time_in_slot)
bysort ID pid slot: keep if time_in_slot == max_time
bysort ID pid slot: keep if _n == 1

gen timeslot = ""
replace timeslot = "04h00" if slot == 1
replace timeslot = "04h30" if slot == 2
replace timeslot = "05h00" if slot == 3
replace timeslot = "05h30" if slot == 4
replace timeslot = "06h00" if slot == 5
replace timeslot = "06h30" if slot == 6
replace timeslot = "07h00" if slot == 7
replace timeslot = "07h30" if slot == 8
replace timeslot = "08h00" if slot == 9
replace timeslot = "08h30" if slot == 10
replace timeslot = "09h00" if slot == 11
replace timeslot = "09h30" if slot == 12
replace timeslot = "10h00" if slot == 13
replace timeslot = "10h30" if slot == 14
replace timeslot = "11h00" if slot == 15
replace timeslot = "11h30" if slot == 16
replace timeslot = "12h00" if slot == 17
replace timeslot = "12h30" if slot == 18
replace timeslot = "13h00" if slot == 19
replace timeslot = "13h30" if slot == 20
replace timeslot = "14h00" if slot == 21
replace timeslot = "14h30" if slot == 22
replace timeslot = "15h00" if slot == 23
replace timeslot = "15h30" if slot == 24
replace timeslot = "16h00" if slot == 25
replace timeslot = "16h30" if slot == 26
replace timeslot = "17h00" if slot == 27
replace timeslot = "17h30" if slot == 28
replace timeslot = "18h00" if slot == 29
replace timeslot = "18h30" if slot == 30
replace timeslot = "19h00" if slot == 31
replace timeslot = "19h30" if slot == 32
replace timeslot = "20h00" if slot == 33
replace timeslot = "20h30" if slot == 34
replace timeslot = "21h00" if slot == 35
replace timeslot = "21h30" if slot == 36
replace timeslot = "22h00" if slot == 37
replace timeslot = "22h30" if slot == 38
replace timeslot = "23h00" if slot == 39
replace timeslot = "23h30" if slot == 40
replace timeslot = "00h00" if slot == 41
replace timeslot = "00h30" if slot == 42
replace timeslot = "01h00" if slot == 43
replace timeslot = "01h30" if slot == 44
replace timeslot = "02h00" if slot == 45
replace timeslot = "02h30" if slot == 46
replace timeslot = "03h00" if slot == 47
replace timeslot = "03h30" if slot == 48

tempfile women_diary
save `women_diary'

*Timetable by employment status

use `women_diary', clear

preserve

gen count = 1
collapse (count) count [pw=weight], by(emp_status timeslot categ)

gsort timeslot emp_status -count
bysort timeslot emp_status: keep if _n == 1

rename categ winner

keep emp_status timeslot winner
reshape wide winner, i(emp_status) j(timeslot) string

gen emp_label = "Not working" if emp_status == 0
replace emp_label = "Wage work" if emp_status == 1
replace emp_label = "Farm work" if emp_status == 2
replace emp_label = "Non-farm business" if emp_status == 3

order emp_label winner04h00 winner04h30 winner05h00 winner05h30 winner06h00 winner06h30 ///
      winner07h00 winner07h30 winner08h00 winner08h30 winner09h00 winner09h30 ///
      winner10h00 winner10h30 winner11h00 winner11h30 winner12h00 winner12h30 ///
      winner13h00 winner13h30 winner14h00 winner14h30 winner15h00 winner15h30 ///
      winner16h00 winner16h30 winner17h00 winner17h30 winner18h00 winner18h30 ///
      winner19h00 winner19h30 winner20h00 winner20h30 winner21h00 winner21h30 ///
      winner22h00 winner22h30 winner23h00 winner23h30 winner00h00 winner00h30 ///
      winner01h00 winner01h30 winner02h00 winner02h30 winner03h00 winner03h30

label values winner* categ_label

mkmat winner*, matrix(winner) rownames(emp_label)
matrix colnames winner = "4h00" "4h30" "5h00" "5h30" "6h00" "6h30" "7h00" "7h30" ///
    "8h00" "8h30" "9h00" "9h30" "10h00" "10h30" "11h00" "11h30" ///
    "12h00" "12h30" "13h00" "13h30" "14h00" "14h30" "15h00" "15h30" ///
    "16h00" "16h30" "17h00" "17h30" "18h00" "18h30" "19h00" "19h30" ///
    "20h00" "20h30" "21h00" "21h30" "22h00" "22h30" "23h00" "23h30" ///
    "0h00" "0h30" "1h00" "1h30" "2h00" "2h30" "3h00" "3h30"

plotmatrix, mat(winner) split(0(1)10) ///
    color(navy blue teal green lime yellow orange red maroon purple) ///
    title("What are Vietnamese women doing throughout the day?") ///
    ylabel(, labsize(vsmall) angle(40)) xlabel(, labsize(vsmall)) ///
    legend(size(vsmall)) ///
    legend(order(1 "Formal employment" 2 "Non-estab production" 3 "Non-estab services" ///
                 4 "Domestic work" 5 "Care work" 6 "Community service" ///
                 7 "Learning" 8 "Social/Leisure" 9 "Media/Entertainment" 10 "Self-care")) ///
    legend(pos(6)) ///
    note("Women aged 15-64. Source: Vietnam Time Use Survey 2022")

graph export "$graphs/timetable_by_empstatus_VN2022.png", replace

restore

*2x2 stratification 

use `women_diary', clear

preserve

gen count = 1
collapse (count) count [pw=weight], by(has_farm_biz has_wage timeslot categ)

gsort timeslot has_farm_biz has_wage -count
bysort timeslot has_farm_biz has_wage: keep if _n == 1

rename categ winner

tostring has_farm_biz, gen(fb_str)
tostring has_wage, gen(wage_str)
gen id = fb_str + wage_str

keep id timeslot winner
reshape wide winner, i(id) j(timeslot) string

gen strat_label = "No farm/biz, No wage" if id == "00"
replace strat_label = "No farm/biz, Has wage" if id == "01"
replace strat_label = "Has farm/biz, No wage" if id == "10"
replace strat_label = "Has farm/biz, Has wage" if id == "11"

order strat_label winner04h00 winner04h30 winner05h00 winner05h30 winner06h00 winner06h30 ///
      winner07h00 winner07h30 winner08h00 winner08h30 winner09h00 winner09h30 ///
      winner10h00 winner10h30 winner11h00 winner11h30 winner12h00 winner12h30 ///
      winner13h00 winner13h30 winner14h00 winner14h30 winner15h00 winner15h30 ///
      winner16h00 winner16h30 winner17h00 winner17h30 winner18h00 winner18h30 ///
      winner19h00 winner19h30 winner20h00 winner20h30 winner21h00 winner21h30 ///
      winner22h00 winner22h30 winner23h00 winner23h30 winner00h00 winner00h30 ///
      winner01h00 winner01h30 winner02h00 winner02h30 winner03h00 winner03h30

label values winner* categ_label

mkmat winner*, matrix(winner2) rownames(strat_label)
matrix colnames winner2 = "4h00" "4h30" "5h00" "5h30" "6h00" "6h30" "7h00" "7h30" ///
    "8h00" "8h30" "9h00" "9h30" "10h00" "10h30" "11h00" "11h30" ///
    "12h00" "12h30" "13h00" "13h30" "14h00" "14h30" "15h00" "15h30" ///
    "16h00" "16h30" "17h00" "17h30" "18h00" "18h30" "19h00" "19h30" ///
    "20h00" "20h30" "21h00" "21h30" "22h00" "22h30" "23h00" "23h30" ///
    "0h00" "0h30" "1h00" "1h30" "2h00" "2h30" "3h00" "3h30"

plotmatrix, mat(winner2) split(0(1)10) ///
    color(navy blue teal green lime yellow orange red maroon purple) ///
    title("What are Vietnamese women doing throughout the day?") ///
    ylabel(, labsize(vsmall) angle(40)) xlabel(, labsize(vsmall)) ///
    legend(size(vsmall)) ///
    legend(order(1 "Formal employment" 2 "Non-estab production" 3 "Non-estab services" ///
                 4 "Domestic work" 5 "Care work" 6 "Community service" ///
                 7 "Learning" 8 "Social/Leisure" 9 "Media/Entertainment" 10 "Self-care")) ///
    legend(pos(6)) ///
    note("Women aged 15-64. Source: Vietnam Time Use Survey 2022")

graph export "$graphs/timetable_2x2_VN2022.png", replace

restore

*Detailed activity codes 

use `women_diary', clear

preserve

gen count = 1
collapse (count) count [pw=weight], by(emp_status timeslot Q401)

gsort timeslot emp_status -count
bysort timeslot emp_status: keep if _n == 1

rename Q401 winner_detailed

keep emp_status timeslot winner_detailed
reshape wide winner_detailed, i(emp_status) j(timeslot) string

gen emp_label = "Not working" if emp_status == 0
replace emp_label = "Wage work" if emp_status == 1
replace emp_label = "Farm work" if emp_status == 2
replace emp_label = "Non-farm business" if emp_status == 3

order emp_label

mkmat winner_detailed*, matrix(detailed) rownames(emp_label)
matrix colnames detailed = "4h00" "4h30" "5h00" "5h30" "6h00" "6h30" "7h00" "7h30" ///
    "8h00" "8h30" "9h00" "9h30" "10h00" "10h30" "11h00" "11h30" ///
    "12h00" "12h30" "13h00" "13h30" "14h00" "14h30" "15h00" "15h30" ///
    "16h00" "16h30" "17h00" "17h30" "18h00" "18h30" "19h00" "19h30" ///
    "20h00" "20h30" "21h00" "21h30" "22h00" "22h30" "23h00" "23h30" ///
    "0h00" "0h30" "1h00" "1h30" "2h00" "2h30" "3h00" "3h30"

plotmatrix, mat(detailed) split(0(200)1600) ///
    color(sienna maroon brown orange_red orange yellow gold navy blue) ///
    title("Detailed activities: What are Vietnamese women doing?") ///
    ylabel(, labsize(vsmall) angle(40)) xlabel(, labsize(vsmall)) ///
    legend(size(vsmall)) ///
    legend(order(1 "101-199: Formal work" 2 "201-399: Family biz/manufacturing" ///
                 3 "401-599: Construction/Services" 4 "601-799: Domestic/Care" ///
                 5 "801-999: Community/Learning" 6 "1001-1199: Social" ///
                 7 "1201-1399: Hobbies/Sports" 8 "1401-1599: Media/Self-care")) ///
    legend(pos(6)) ///
    note("Women aged 15-64. Source: Vietnam Time Use Survey 2022")

graph export "$graphs/detailed_timetable_VN2022.png", replace

restore
