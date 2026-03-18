
use "/Users/annieshrestha/MDM_Dataset_Coded.dta"
****bar graphs****

************************************ MATHS TEST ******************************
preserve
collapse (mean) mean=MathsTest (sd) sd=MathsTest (semean) semean=MathsTest (count) n=MathsTest, by (MDM)
generate ub=mean+semean
generate lb=mean-semean

generate mathstestmean=mean if MDM==1
replace mathstestmean=mean+2.5 if MDM==0

gen tolabel = round(mean, 0.01)

sort mathstestmean
list mathstestmean mean MDM ,sepby(MDM)


twoway(bar mean mathstestmean if MDM==1, bcolor(gs5)) ///
(scatter mean mathstestmean if MDM==1, mlabel(tolabel) msym(none) mlabposition(1) mlabcolor(black)) ///
(bar mean mathstestmean if MDM==0, bcolor(gs10)) ///
(scatter mean mathstestmean if MDM==0, mlabel(tolabel) msym(none) mlabposition(1) mlabcolor(black)) ///
(rcap ub lb mathstestmean, bcolor(gs0)), ///
yscale(off) legend(row(1) order(1 "MDM" 3 "Non-MDM")) ///
title("Mean Scores - Maths Test", color(gs0)) xtitle(" ") ylab( ,nogrid) xlab( ,notick) ///
graphregion(color(white)) graphregion(lcolor(black) lwidth(medium))

*graph save "Graph" "/Users/annieshrestha/Desktop/MDM/Output/MDM_Maths Test.gph", replace
restore
************************** COMBINED SUBTRACTION ******************************
preserve
collapse (mean) mean=CombinedSubtraction (sd) sd=CombinedSubtraction (semean) semean=CombinedSubtraction (count) n=CombinedSubtraction, by (MDM)
generate ub=mean+semean
generate lb=mean-semean

generate mathstestmean=mean if MDM==1
replace mathstestmean=mean+2.5 if MDM==0

gen tolabel = round(mean, 0.01)

sort mathstestmean
list mathstestmean mean MDM ,sepby(MDM)

twoway(bar mean mathstestmean if MDM==1)(bar mean mathstestmean if MDM==0) (rcap ub lb mathstestmean)
edit mean mathstestmean semean

twoway(bar mean mathstestmean if MDM==1, bcolor(gs5)) ///
(scatter mean mathstestmean if MDM==1, mlabel(tolabel) msym(none) mlabposition(1) mlabcolor(black)) ///
(bar mean mathstestmean if MDM==0, bcolor(gs10)) ///
(scatter mean mathstestmean if MDM==0, mlabel(tolabel) msym(none) mlabposition(1) mlabcolor(black)) ///
(rcap ub lb mathstestmean, bcolor(gs0)), ///
yscale(off) legend(row(1) order(1 "MDM" 3 "Non-MDM")) ///
title("Mean Scores - Combined Subtraction", color(gs0)) xtitle(" ") ylab( ,nogrid) xlab( ,notick) ///
graphregion(color(white)) graphregion(lcolor(black) lwidth(medium))

*graph save "Graph" "/Users/annieshrestha/Desktop/MDM/Output/MDM_Combined Subtraction.gph"

restore

************************** COMBINED MULTIPLICATION ****************************
preserve
collapse (mean) mean=CombinedMultiplication (sd) sd=CombinedMultiplication (semean) semean=CombinedMultiplication (count) n=CombinedMultiplication, by (MDM)
generate ub=mean+semean
generate lb=mean-semean

generate mathstestmean=mean if MDM==1
replace mathstestmean=mean+2.5 if MDM==0

gen tolabel = round(mean, 0.01)

sort mathstestmean
list mathstestmean mean MDM ,sepby(MDM)

twoway(bar mean mathstestmean if MDM==1, bcolor(gs5)) ///
(scatter mean mathstestmean if MDM==1, mlabel(tolabel) msym(none) mlabposition(1) mlabcolor(black)) ///
(bar mean mathstestmean if MDM==0, bcolor(gs10)) ///
(scatter mean mathstestmean if MDM==0, mlabel(tolabel) msym(none) mlabposition(1) mlabcolor(black)) ///
(rcap ub lb mathstestmean, bcolor(gs0)), ///
yscale(off) legend(row(1) order(1 "MDM" 3 "Non-MDM")) ///
title("Mean Scores - Combined Multiplication", color(gs0)) xtitle(" ") ylab( ,nogrid) xlab( ,notick) ///
graphregion(color(white)) graphregion(lcolor(black) lwidth(medium))

*graph save "Graph" "/Users/annieshrestha/Desktop/MDM/Output/MDM_Combined Multiplication.gph"

restore

************************** COMBINED DIVISION ******************************
preserve
collapse (mean) mean=CombinedDivision (sd) sd=CombinedDivision (semean) semean=CombinedDivision (count) n=CombinedDivision, by (MDM)
generate ub=mean+semean
generate lb=mean-semean

generate mathstestmean=mean if MDM==1
replace mathstestmean=mean+2.5 if MDM==0

gen tolabel = round(mean, 0.01)

sort mathstestmean
list mathstestmean mean MDM ,sepby(MDM)

twoway(bar mean mathstestmean if MDM==1, bcolor(gs5)) ///
(scatter mean mathstestmean if MDM==1, mlabel(tolabel) msym(none) mlabposition(1) mlabcolor(black)) ///
(bar mean mathstestmean if MDM==0, bcolor(gs10)) ///
(scatter mean mathstestmean if MDM==0, mlabel(tolabel) msym(none) mlabposition(1) mlabcolor(black)) ///
(rcap ub lb mathstestmean, bcolor(gs0)), ///
yscale(off) legend(row(1) order(1 "MDM" 3 "Non-MDM")) ///
title("Mean Scores - Combined Division", color(gs0)) xtitle(" ") ylab( ,nogrid) xlab( ,notick) ///
graphregion(color(white)) graphregion(lcolor(black) lwidth(medium))

*graph save "Graph" "/Users/annieshrestha/Desktop/MDM/Output/MDM_Combined Division.gph"

restore

grc1leg "/Users/annieshrestha/Desktop/MDM/Output/MDM_Maths Test.gph" "/Users/annieshrestha/Desktop/MDM/Output/MDM_Combined Subtraction.gph" "/Users/annieshrestha/Desktop/MDM/Output/MDM_Combined Multiplication.gph" "/Users/annieshrestha/Desktop/MDM/Output/MDM_Combined Division.gph",title(Mean Difference, color(gs0)) graphregion(color(white)) graphregion(lcolor(black) lwidth(medium)) legendfrom("/Users/annieshrestha/Desktop/MDM/Output/MDM_Maths Test.gph") 

************************** NUMBER RECOGNITION ******************************
preserve
collapse (mean) mean=NumberRecognition (sd) sd=NumberRecognition (semean) semean=NumberRecognition (count) n=NumberRecognition, by (MDM)
generate ub=mean+semean
generate lb=mean-semean

generate mathstestmean=mean if MDM==1
replace mathstestmean=mean+2.5 if MDM==0

gen tolabel = round(mean, 0.01)

sort mathstestmean
list mathstestmean mean MDM ,sepby(MDM)

twoway(bar mean mathstestmean if MDM==1, bcolor(gs5)) ///
(scatter mean mathstestmean if MDM==1, mlabel(tolabel) msym(none) mlabposition(1) mlabcolor(black)) ///
(bar mean mathstestmean if MDM==0, bcolor(gs10)) ///
(scatter mean mathstestmean if MDM==0, mlabel(tolabel) msym(none) mlabposition(1) mlabcolor(black)) ///
(rcap ub lb mathstestmean, bcolor(gs0)), ///
yscale(off) legend(row(1) order(1 "MDM" 3 "Non-MDM")) ///
title("Mean Scores - Number Recognition", color(gs0)) xtitle(" ") ylab( ,nogrid) xlab( ,notick) ///
graphregion(color(white)) graphregion(lcolor(black) lwidth(medium))

restore

******************************* DAILY TASK ************************************

preserve

collapse (mean) mean=DailyTask (sd) sd=DailyTask (semean) semean=DailyTask (count) n=DailyTask, by (MDM)
generate ub=mean+semean
generate lb=mean-semean

generate mathstestmean=mean if MDM==1
replace mathstestmean=mean+2.5 if MDM==0

gen tolabel = round(mean, 0.01)

sort mathstestmean
list mathstestmean mean MDM ,sepby(MDM)

twoway(bar mean mathstestmean if MDM==1, bcolor(gs5)) ///
(scatter mean mathstestmean if MDM==1, mlabel(tolabel) msym(none) mlabposition(1) mlabcolor(black)) ///
(bar mean mathstestmean if MDM==0, bcolor(gs10)) ///
(scatter mean mathstestmean if MDM==0, mlabel(tolabel) msym(none) mlabposition(1) mlabcolor(black)) ///
(rcap ub lb mathstestmean, bcolor(gs0)), ///
yscale(off) legend(row(1) order(1 "MDM" 3 "Non-MDM")) ///
title("Mean Scores - Daily Task", color(gs0)) xtitle(" ") ylab( ,nogrid) xlab( ,notick) ///
graphregion(color(white)) graphregion(lcolor(black) lwidth(medium))

restore


************************** FINANCIAL CALCULATION ******************************

preserve

collapse (mean) mean=FinancialCalculation (sd) sd=FinancialCalculation (semean) semean=FinancialCalculation (count) n=FinancialCalculation, by (MDM)
generate ub=mean+semean
generate lb=mean-semean

generate mathstestmean=mean if MDM==1
replace mathstestmean=mean+2.5 if MDM==0

gen tolabel = round(mean, 0.01)

sort mathstestmean
list mathstestmean mean MDM ,sepby(MDM)

twoway(bar mean mathstestmean if MDM==1, bcolor(gs5)) ///
(scatter mean mathstestmean if MDM==1, mlabel(tolabel) msym(none) mlabposition(1) mlabcolor(black)) ///
(bar mean mathstestmean if MDM==0, bcolor(gs10)) ///
(scatter mean mathstestmean if MDM==0, mlabel(tolabel) msym(none) mlabposition(1) mlabcolor(black)) ///
(rcap ub lb mathstestmean, bcolor(gs0)), ///
yscale(off) legend(row(1) order(1 "MDM" 3 "Non-MDM")) ///
title("Mean Scores - Financial Calculation", color(gs0)) xtitle(" ") ylab( ,nogrid) xlab( ,notick) ///
graphregion(color(white)) graphregion(lcolor(black) lwidth(medium))

restore

***************************** SIMPLE CALCULATION ********************************

preserve
collapse (mean) mean=SimpleCalculation (sd) sd=SimpleCalculation (semean) semean=SimpleCalculation (count) n=SimpleCalculation, by (MDM)
generate ub=mean+semean
generate lb=mean-semean

generate mathstestmean=mean if MDM==1
replace mathstestmean=mean+2.5 if MDM==0

gen tolabel = round(mean, 0.01)

sort mathstestmean
list mathstestmean mean MDM ,sepby(MDM)

twoway(bar mean mathstestmean if MDM==1, bcolor(gs5)) ///
(scatter mean mathstestmean if MDM==1, mlabel(tolabel) msym(none) mlabposition(1) mlabcolor(black)) ///
(bar mean mathstestmean if MDM==0, bcolor(gs10)) ///
(scatter mean mathstestmean if MDM==0, mlabel(tolabel) msym(none) mlabposition(1) mlabcolor(black)) ///
(rcap ub lb mathstestmean, bcolor(gs0)), ///
yscale(off) legend(row(1) order(1 "MDM" 3 "Non-MDM")) ///
title("Mean Scores - Simple Calculation", color(gs0)) xtitle(" ") ylab( ,nogrid) xlab( ,notick) ///
graphregion(color(white)) graphregion(lcolor(black) lwidth(medium))

restore





**************
collapse (mean) mean=CombinedReading (sd) sd=CombinedReading (semean) semean=CombinedReading (count) n=CombinedReading, by (MDM)
generate ub=mean+semean
generate lb=mean-semean

generate mathstestmean=mean if MDM==1
replace mathstestmean=mean+2.5 if MDM==0
sort mathstestmean
list mathstestmean mean MDM ,sepby(MDM)

twoway(bar mean mathstestmean if MDM==1)(bar mean mathstestmean if MDM==0) (rcap ub lb mathstestmean)
edit mean mathstestmean semean
**************
collapse (mean) mean=EnglishReading (sd) sd=EnglishReading (semean) semean=EnglishReading (count) n=EnglishReading, by (MDM)
generate ub=mean+semean
generate lb=mean-semean

generate mathstestmean=mean if MDM==1
replace mathstestmean=mean+2.5 if MDM==0
sort mathstestmean
list mathstestmean mean MDM ,sepby(MDM)

twoway(bar mean mathstestmean if MDM==1)(bar mean mathstestmean if MDM==0) (rcap ub lb mathstestmean)
edit mean mathstestmean semean
********
collapse (mean) mean=SecondLanguageReading (sd) sd=SecondLanguageReading (semean) semean=SecondLanguageReading (count) n=SecondLanguageReading, by (MDM)
generate ub=mean+semean
generate lb=mean-semean

generate mathstestmean=mean if MDM==1
replace mathstestmean=mean+2.5 if MDM==0
sort mathstestmean
list mathstestmean mean MDM ,sepby(MDM)

twoway(bar mean mathstestmean if MDM==1)(bar mean mathstestmean if MDM==0) (rcap ub lb mathstestmean)
edit mean mathstestmean semean
************
collapse (mean) mean=BMI (sd) sd=BMI (semean) semean=BMI (count) n=BMI, by (MDM)
generate ub=mean+semean
generate lb=mean-semean

generate mathstestmean=mean if MDM==1
replace mathstestmean=mean+2.5 if MDM==0
sort mathstestmean
list mathstestmean mean MDM ,sepby(MDM)

twoway(bar mean mathstestmean if MDM==1)(bar mean mathstestmean if MDM==0) (rcap ub lb mathstestmean)
edit mean mathstestmean semean
***************
collapse (mean) mean=Attendance (sd) sd=Attendance (semean) semean=Attendance (count) n=Attendance, by (MDM)
generate ub=mean+semean
generate lb=mean-semean

generate mathstestmean=mean if MDM==1
replace mathstestmean=mean+2.5 if MDM==0
sort mathstestmean
list mathstestmean mean MDM ,sepby(MDM)

twoway(bar mean mathstestmean if MDM==1)(bar mean mathstestmean if MDM==0) (rcap ub lb mathstestmean)
edit mean mathstestmean semean

