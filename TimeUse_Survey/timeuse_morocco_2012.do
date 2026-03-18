global own "/Users/annieshrestha/Downloads/WIL/Time Use/Raw data/Morocco/"
global data "$own"
global graphs "$own/Graphs/"
capture mkdir "$graphs"

* Household 
import delimited using "$data/ménage_ENET.csv", delimiters(";") clear

* keep male-headed married households
keep if sexe_cm   == 1
keep if etatmatrimonial_cm == 2
keep if age_cm    >= 18

* restrict to nuclear households so the only married adult female = wife
* type_ménage 2 = nuclear complete, 3 = nuclear incomplete (no children)
keep if inlist(type_ménage, 2, 3)

* husband business: auto-employé mirroring SA
* statut_professionnel_cm: 1=Salarié, 2=Auto-employé, 3=Non rémunéré
gen has_nf_business = (statut_professionnel_cm == "2") if statut_professionnel_cm != ""
gen has_f_business  = (statut_professionnel_cm == "2" & inlist(catégories_so, "4")) ///
                      if statut_professionnel_cm != ""
gen has_business    = has_nf_business == 1 | has_f_business == 1

label define has_business_l 0 "husband not SE" 1 "husband SE"
label values has_business    has_business_l
label values has_nf_business has_business_l
label values has_f_business  has_business_l
tab has_business

keep n_ménage has_business has_nf_business has_f_business milieu age_cm
tempfile hh
save `hh'

* AAdult diary file
import delimited using "$data/carnet_adulte_ENET2012.csv", delimiters(";") clear

* age groups
gen age_grp = .
replace age_grp = 1 if age <  15 & age != .
replace age_grp = 2 if age >= 15 & age < 65 & age != .
replace age_grp = 3 if age >= 65 & age != .

label define age_grp_l 1 "below working age" 2 "working age" 3 "above working age"
label values age_grp age_grp_l

* sex
label define sex_l 1 "Male" 2 "Female"
label values sexe sex_l

* employment status 
gen self_emp = (statut_professionnel == "2") if statut_professionnel != ""
gen wage_emp = (statut_professionnel == "1") if statut_professionnel != ""

label define self_emp_l 0 "not self-employed" 1 "self-employed"
label define wage_emp_l 0 "not wage employed" 1 "wage employed"
label values self_emp self_emp_l
label values wage_emp wage_emp_l

* destring weight
destring coef_individu, dpcomma replace

* keep married adult women only
keep if sexe            == 2
keep if etat_matrimonial == 2
keep if age             >= 18

* merge with household file
merge m:1 n_ménage using `hh'
keep if _merge == 3
drop _merge

* age gap restriction 
gen age_gap = abs(age - age_cm)
keep if age_gap <= 20

* wife employment: wage or unpaid family worker
gen wage_wife = (statut_professionnel == "1" | statut_professionnel == "3") ///
                if statut_professionnel != ""

label define wage_wife_l 0 "wife no wage job" 1 "wife wage job"
label values wage_wife wage_wife_l
tab wage_wife

* urban/rural
label define milieu_l 1 "Urban" 2 "Rural"
label values milieu milieu_l

* household group
gen group = .
replace group = 1 if has_business == 0 & wage_wife == 0
replace group = 2 if has_business == 0 & wage_wife == 1
replace group = 3 if has_business == 1 & wage_wife == 0
replace group = 4 if has_business == 1 & wage_wife == 1

label define group_l                          ///
    1 "No business husb, no wage wife"        ///
    2 "No business husb, wage wife"           ///
    3 "Business husb, no wage wife"           ///
    4 "Business husb, wage wife"
label values group group_l
tab group

* 10 broad categories
* broad1: formal/non-agricultural employment
gen broad1  = dureeg31

* broad2: agricultural/farm work (non-establishment production)
gen broad2  = dureeg32

* broad3: secondary professional activity (non-establishment services)
gen broad3  = dureeg33

* broad4: domestic work
gen broad4  = dureeg5

* broad5: care work
gen broad5  = dureeg6

* broad6: community service (volunteering + religious)
gen broad6  = dureeg83 + dureeg84 + dureeg9

* broad7: learning
gen broad7  = dureeg4

* broad8: social activities (visits + conversations)
gen broad8  = dureeg81 + dureeg82

* broad9: media/entertainment/leisure
gen broad9  = dureeg71 + dureeg72 + dureeg73 + dureeg74 + ///
              dureeg75 + dureeg76 + dureeg77 + dureeg78 + dureeg79

* broad10: self-care (sleep + meals + personal care)
gen broad10 = dureeg0 + dureeg1 + dureeg2

label define categ_label                   ///
    1  "Employment in establishment"       ///
    2  "Non-establishment production work" ///
    3  "Non-establishment service work"    ///
    4  "Domestic work"                     ///
    5  "Care work"                         ///
    6  "Community service"                 ///
    7  "Learning"                          ///
    8  "Social activities"                 ///
    9  "Media/Entertainment"               ///
    10 "Self-care", modify

collapse (mean) broad1 broad2 broad3 broad4 broad5 ///
               broad6 broad7 broad8 broad9 broad10  ///
         [pw = coef_individu], by(group)

reshape long broad, i(group) j(activity)
reshape wide broad, i(activity) j(group)

label values activity .

graph bar broad1 broad2 broad3 broad4,                                        ///
    over(activity, relabel(                                                    ///
        1  "Employment in estab."                                              ///
        2  "Non-estab. production"                                             ///
        3  "Non-estab. services"                                               ///
        4  "Domestic work"                                                     ///
        5  "Care work"                                                         ///
        6  "Community service"                                                 ///
        7  "Learning"                                                          ///
        8  "Social activities"                                                 ///
        9  "Media/Entertainment"                                               ///
        10 "Self-care")                                                        ///
        label(angle(45) labsize(vsmall)))                                      ///
    title("What are women doing? Morocco TUS 2012")                            ///
    ytitle("Minutes per day")                                                  ///
    legend(order(1 "No business husb, no wage wife"                           ///
                 2 "No business husb, wage wife"                              ///
                 3 "Business husb, no wage wife"                              ///
                 4 "Business husb, wage wife")                                ///
           size(vsmall) pos(6) rows(2))                                        ///
    note("Married women 18+, nuclear households, age gap ≤20 years."          ///
         "All days. Weighted means.", size(vsmall))                            ///
    scheme(s1color)                                                            ///
    bar(1, color(navy)) bar(2, color(maroon))                                  ///
    bar(3, color(forest_green)) bar(4, color(orange))                          ///
    name(g_all, replace)

graph export "$graphs/whatarewomendoing_MA2012.png", replace width(2400)
