clear all

global root   "/Users/annieshrestha/Downloads/WIL/Time Use/Raw data/Kenya/Time Use/2021"
global data   "$root"
global graphs "$root/Graphs"
global tables "$root/Tables"

use "$data/time_use_final_ver13.dta", clear

* 0) IDs
egen hh_uid = group(clid strid hhid)
rename hhid__id pid

* 1) Time-use outcomes (broad aggregates) + main daily category

gen total_minutes = t55
label var total_minutes "Total minutes in day (approx 1440)"

gen emp_min   = t11
gen own_min   = t12
gen dom_min   = t13
gen care_min  = t14
gen vol_min   = t15
gen learn_min = t16
gen soc_min   = t17
gen leis_min  = t18
gen self_min  = t19

* Detailed employment
gen emp_corp_min      = t211  // Employment in corporations, government, NPOs
gen emp_hh_goods_min  = t212  // Employment in household enterprises to produce goods
gen emp_hh_serv_min   = t213  // Employment in households/HH enterprises to provide services
gen emp_breaks_min    = t214  // Ancillary activities and breaks
gen emp_training_min  = t215  // Training and studies related to employment
gen emp_seeking_min   = t216  // Seeking employment
gen emp_setup_biz_min = t217  // Setting up a business
gen emp_travel_min    = t218  // Travelling and commuting for employment

* Detailed own use production
gen own_agric_min    = t221  // Agriculture, forestry, fishing, mining for own use
gen own_goods_min    = t222  // Making/processing goods for own use
gen own_constr_min   = t223  // Construction activities for own use
gen own_water_min    = t224  // Supplying water and fuel for own household
gen own_transport_min = t225  // Travelling, moving, transporting goods/persons

*if people have a nonflex job (t211 >0 ) then all the other activities (break, travel) related to this job are nonflex. If people have both, the related activity time is split in half across flex an non-flex
gen wage_wk = t211 !=. & t211>0
gen SE_wk     = t212>0 | t213 >0

gen tot_nonflex = t211/60 
gen tot_semi_flex = (t212 + t213) / 60 
gen total_altwork = (t214 + t215 + t216 + t217 + t218)/60 
replace tot_nonflex = tot_nonflex + total_altwork if tot_nonflex >0 & tot_semi_flex ==0 
replace tot_semi_flex = tot_semi_flex + total_altwork if tot_nonflex ==0 
replace tot_semi_flex = tot_semi_flex + total_altwork/2 if tot_nonflex >0 & tot_semi_flex >0 
replace tot_nonflex = tot_nonflex + total_altwork/2 if tot_nonflex >0 & tot_semi_flex >0 

replace tot_semi_flex = tot_semi_flex + t12/60 
gen tot_flex = ( t13 + t14 + t15 + t16 + t17 + t18)/60
gen tot_sleep = (t19)/60


gen total = tot_semi_flex + tot_flex + tot_sleep + tot_nonflex 
tab total 
/*
gen tot_nonflex = t11/60 if wage_wk ==1 & SE_wk==0 
replace tot_nonflex = (t211 + (t214 + t215 + t216  + t217 + t218)/2)/60  if wage_wk & SE_wk
replace tot_nonflex = 0 if tot_nonflex==. 

gen tot_semi_flex = (t11 + t12)/60  if SE_wk ==1 & wage_wk==0 
replace tot_semi_flex = (t212 + t213 + (t214 + t215 + t216  + t217 + t218)/2 + t12)/60 if wage_wk==1 & SE_wk==1
replace tot_semi_flex =  (t214 + t215 + t216  + t217 + t218)/60 if wage_wk==0 & SE_wk==0
replace tot_semi_flex = 0 if tot_semi_flex==. 

*/
 
egen max_agg = rowmax(emp_min own_min dom_min care_min vol_min ///
                      learn_min soc_min leis_min self_min)

gen categ_agg = .
replace categ_agg = 1 if emp_min   == max_agg & max_agg > 0
replace categ_agg = 2 if own_min   == max_agg & missing(categ_agg) & max_agg > 0
replace categ_agg = 3 if dom_min   == max_agg & missing(categ_agg) & max_agg > 0
replace categ_agg = 4 if care_min  == max_agg & missing(categ_agg) & max_agg > 0
replace categ_agg = 5 if vol_min   == max_agg & missing(categ_agg) & max_agg > 0
replace categ_agg = 6 if learn_min == max_agg & missing(categ_agg) & max_agg > 0
replace categ_agg = 7 if soc_min   == max_agg & missing(categ_agg) & max_agg > 0
replace categ_agg = 8 if leis_min  == max_agg & missing(categ_agg) & max_agg > 0
replace categ_agg = 9 if self_min  == max_agg & missing(categ_agg) & max_agg > 0
drop max_agg

label define categ_agg_lbl ///
    1 "Employment" ///
    2 "Own-use production" ///
    3 "Domestic work" ///
    4 "Care work" ///
    5 "Volunteer / other unpaid work" ///
    6 "Learning" ///
    7 "Social/community/religious" ///
    8 "Leisure/media/sports" ///
    9 "Self-care", replace
label values categ_agg categ_agg_lbl

preserve
keep hh_uid pid Person_Day_Weight total_minutes ///
     emp_min own_min dom_min care_min vol_min learn_min soc_min leis_min self_min ///
     emp_corp_min emp_hh_goods_min emp_hh_serv_min emp_breaks_min emp_training_min ///
     emp_seeking_min emp_setup_biz_min emp_travel_min ///
     own_agric_min own_goods_min own_constr_min own_water_min own_transport_min ///
     categ_agg house6_13 houseless6 b05_years resid county tot* c08 
rename pid person
tempfile outcomes
save `outcomes'
restore

* 2) Demographics + labor status variables
gen byte has_nf_business = (d02_2 == 1) 
gen byte has_f_business  = (d02_3 == 1)
gen byte helps_unpaid    = (d02_4 == 1 | d02_5 == 1) 
gen byte has_wage_job    = (d02_1 == 1) 

* Sex
gen byte sex = b04
assert inlist(sex,1,2) if !missing(sex)

* Age
gen age_years = b05_years
drop if missing(age_years)

* Employment status proxies
gen byte wage_emp = (d02_1 == 1) if !missing(d02_1)
gen byte self_emp = (d02_2 == 1 | d02_3 == 1) if !missing(d02_2, d02_3)

* Married (b07: 1 monogamous, 2 polygamous)
gen byte married = inlist(b07, 1, 2)

* Keep head/spouse
keep if inlist(b03, 1, 2)

* Require exactly one head and one spouse
bysort hh_uid: egen n_head   = total(b03==1)
bysort hh_uid: egen n_spouse = total(b03==2)
keep if n_head==1 & n_spouse==1
drop n_head n_spouse
 
* Require one male and one female 
bysort hh_uid: egen n_male   = total(sex==1)
bysort hh_uid: egen n_female = total(sex==2)
keep if n_male==1 & n_female==1
drop n_male n_female

* Both adults
bysort hh_uid: egen major = total(age_years>=18 & age_years<.)
keep if major==2
drop major

* Both married
bysort hh_uid: egen nmar = total(married==1)
keep if nmar==2
drop nmar

* Age difference <= 20
bysort hh_uid: egen maxa = max(age_years)
bysort hh_uid: egen mina = min(age_years)
gen age_dif = maxa - mina
keep if age_dif <= 20
drop maxa mina age_dif

* Children indicators
gen byte child18h = (houseNochild == 0) if !missing(houseNochild)
gen byte child06h = (houseless6  == 1) if !missing(houseless6)     

keep hh_uid has* helps* sex self_emp wage_emp ///
     pid Person_Day_Weight age_years child18h child06h resid county tot*

bysort hh_uid: assert _N==2
bysort hh_uid: egen has_female = total(sex==2)
bysort hh_uid: egen has_male   = total(sex==1)
assert has_female==1 & has_male==1
drop has_female has_male

reshape wide has* helps* self_emp wage_emp ///
             pid Person_Day_Weight ///
             age_years child18h child06h  resid county tot*, ///
       i(hh_uid) j(sex)

rename pid2 person

*3) 4x9 matrix of WOMEN'S HOURS per day by group

* Group defs on couple-wide file
gen byte has_business1 = (has_nf_business1==1 | has_f_business1==1) if !missing(has_nf_business1, has_f_business1)

* Merge wives' daily minutes 
merge 1:1 hh_uid person using `outcomes'
keep if _merge==3
drop _merge

gen wage_wife = wage_emp2
label var wage_wife "Wife has wage employment"

* minutes -> hours
foreach v in emp_min own_min dom_min care_min vol_min learn_min soc_min leis_min self_min {
    gen h_`v' = `v'/60
}

* minutes -> hours (detailed employment)
foreach v in emp_corp_min emp_hh_goods_min emp_hh_serv_min emp_breaks_min ///
             emp_training_min emp_seeking_min emp_setup_biz_min emp_travel_min {
    gen h_`v' = `v'/60
}

* minutes -> hours (detailed own-use production)
foreach v in own_agric_min own_goods_min own_constr_min own_water_min own_transport_min {
    gen h_`v' = `v'/60
}

label define wage 0 "no wage job" 1 "wife has wage"
label values wage_wife wage

label define business 0 "husband has no business" 1 "husband has business"
label values has_business1 business


* Graph 1: Broad 9 categories
graph hbar h_emp_min h_own_min h_dom_min h_care_min h_vol_min h_learn_min ///
          h_soc_min h_leis_min h_self_min [pw = Person_Day_Weight2], ///
    over(has_business1) over(wage_wife) stack asyvar label ///
    legend(order(1 "employment" 2 "own account work" 3 "domestic work" ///
                 4 "care work" 5 "volunteer/unpaid work" 6 "learning" ///
                 7 "social activities" 8 "leisure" 9 "selfcare")) ///
    legend(pos(6) row(3) size(vsmall)) ///
    name(graph_9cat, replace)
graph export "$graphs/chart_9categories_KE2021.png", replace

* Graph 2: Flexibility categories
graph bar tot_sleep2 tot_nonflex2 tot_semi_flex2 tot_flex2 [pw = Person_Day_Weight2], over(has_business1) by(wage_wife,  legend(pos(6)) title("Wives' schedules - KE 2021 Time Use") note ("")) stack legend(row(2)) legend(order( 1 "Sleep time" 2 "Non-flexible time (wage)" 3 "Semi-flexible time (SE)" 4 "Flexible time (leisure, social, dom/care work)")) bar(1, fcolor(edkblue) color(edkblue))  bar(2, fcolor(orange_red) color(orange_red)) bar(3, fcolor(orange) color(orange))  bar(4, fcolor(gold) color(gold))
graph export "$graphs/chart_total_flextime_KE2021.png", replace

* Graph 3: Detailed employment breakdown
graph hbar h_emp_corp_min h_emp_hh_goods_min h_emp_hh_serv_min h_emp_breaks_min ///
          h_emp_training_min h_emp_seeking_min h_emp_setup_biz_min h_emp_travel_min ///
          [pw = Person_Day_Weight2], ///
    over(has_business1) over(wage_wife) stack asyvar ///
    legend(order(1 "Corp/Govt/NPO" 2 "HH enterprise (goods)" ///
                 3 "HH enterprise (services)" 4 "Breaks/ancillary" ///
                 5 "Training/studies" 6 "Job seeking" ///
                 7 "Setting up business" 8 "Commuting/travel") ///
           pos(6) row(3) size(vsmall)) ///
    title("Women's Employment Activities - Detailed") ///
    ytitle("Hours per day") ///
    name(graph_emp_detail, replace)
graph export "$graphs/chart_employment_detail_KE2021.png", replace width(2000)

* Graph 4: Detailed own use production breakdown
graph hbar h_own_agric_min h_own_goods_min h_own_constr_min h_own_water_min h_own_transport_min ///
          [pw = Person_Day_Weight2], ///
    over(has_business1) over(wage_wife) stack asyvar ///
    legend(order(1 "Agriculture/forestry/fishing" 2 "Making/processing goods" ///
                 3 "Construction" 4 "Water/fuel supply" 5 "Transport/moving") ///
           pos(6) row(2) size(vsmall)) ///
    title("Women's Own-Use Production Activities - Detailed") ///
    ytitle("Hours per day") ///
    name(graph_own_detail, replace)
graph export "$graphs/chart_ownuse_detail_KE2021.png", replace width(2000)


reg tot_nonflex2 i.has_business1##i.wage_wife age_years1 age_years2 i.county1 i.resid1 c08 [pw=Person_Day_Weight] 
eststo nonflex_hours
reg tot_semi_flex2 i.has_business1##i.wage_wife age_years1 age_years2 i.county1 i.resid1 c08 [pw=Person_Day_Weight]
eststo semiflex_hours
reg tot_flex2 i.has_business1##i.wage_wife age_years1 age_years2 i.county1 i.resid1 c08 [pw=Person_Day_Weight]
eststo flex_hours
reg tot_sleep2 i.has_business1##i.wage_wife age_years1 age_years2 i.county1 i.resid1 c08 [pw=Person_Day_Weight]
eststo sleep_hours

esttab *hours using "$tables/KE2021_regtothours.tex", ///
    keep(*wage* *business*) noomitted nobase replace label ///
    stat(r2 N) style(tex) starlevels(* 0.10 ** 0.05 *** 0.01) 


* Weighted mean hours by group
collapse (mean) h_emp_min h_own_min h_dom_min h_care_min h_vol_min h_learn_min ///
                h_soc_min h_leis_min h_self_min ///
                h_emp_corp_min h_emp_hh_goods_min h_emp_hh_serv_min h_emp_breaks_min ///
                h_emp_training_min h_emp_seeking_min h_emp_setup_biz_min h_emp_travel_min ///
                h_own_agric_min h_own_goods_min h_own_constr_min h_own_water_min h_own_transport_min ///
    [pw=Person_Day_Weight2], by(wage_wife has_business1)

* Row labels 
gen str2 id = string(wage_wife,"%1.0f") + string(has_business1,"%1.0f")
gen str40 idd = ""
replace idd = "No business husb, no wage wife" if id=="00"
replace idd = "No business husb, wage wife"    if id=="10"
replace idd = "Business husb, no wage wife"    if id=="01"
replace idd = "Business husb, wage wife"       if id=="11"

gen order = .
replace order = 1 if id=="00"
replace order = 2 if id=="10"
replace order = 3 if id=="01"
replace order = 4 if id=="11"
sort order

* Matrix (hours) - 
mkmat h_emp_min h_own_min h_dom_min h_care_min h_vol_min h_learn_min ///
      h_soc_min h_leis_min h_self_min, matrix(H) rownames(idd)
matrix colnames H = "Employment" "Own-use" "Domestic" "Care" "Volunteer" ///
                    "Learning" "Social" "Leisure" "Self-care"
matrix list H
matrix M = 60*H

* Matrix (hours) - employment detail
mkmat h_emp_corp_min h_emp_hh_goods_min h_emp_hh_serv_min h_emp_breaks_min ///
      h_emp_training_min h_emp_seeking_min h_emp_setup_biz_min h_emp_travel_min, ///
      matrix(H_emp_detail) rownames(idd)
matrix colnames H_emp_detail = "Corp/Govt" "HH-Goods" "HH-Serv" "Breaks" ///
                               "Training" "JobSeek" "SetupBiz" "Commute"
matrix list H_emp_detail

* Matrix (hours) - own-use production detail
mkmat h_own_agric_min h_own_goods_min h_own_constr_min h_own_water_min ///
      h_own_transport_min, matrix(H_own_detail) rownames(idd)
matrix colnames H_own_detail = "Agriculture" "GoodsProd" "Construction" ///
                               "Water/Fuel" "Transport"
matrix list H_own_detail
