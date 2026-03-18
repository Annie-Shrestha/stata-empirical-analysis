//*Graphs*//
use "Updated new project dataset.dta"
preserve
/*Khasi Karbi*/

*Loan default by gender*
collapse (mean) meanvar = group_default (sd) sdvar=group_default (count) n=group_default, by(female)
generate hivar = meanvar + invttail(n-1,0.025)*(sdvar / sqrt(n))
generate lowvar = meanvar - invttail(n-1,0.025)*(sdvar / sqrt(n))
gen fk = female+2 if female==0
replace fk=female+3 if female==1
sort fk
twoway (bar meanvar fk if female==0) (bar meanvar fk if female==1) (rcap hivar lowvar fk), yscale(off) legend(row(1) order(1 "Male" 2 "Female") )  title("Loan Default") xtitle("Pooled") xlabel(, nolabels noticks)
restore
preserve
*Loan Default by gender and society*
collapse (mean) meanvar = group_default (sd) sdvar=group_default (count) n=group_default, by(female khasi)
generate hivar = meanvar + invttail(n-1,0.025)*(sdvar / sqrt(n))
generate lowvar = meanvar - invttail(n-1,0.025)*(sdvar / sqrt(n))
gen fk = female+1 if khasi==0
replace fk=female+4 if khasi==1
sort fk
twoway (bar meanvar fk if female==0) (bar meanvar fk if female==1) (rcap hivar lowvar fk), yscale(off) legend(row(1) order(1 "Male" 2 "Female") ) xlabel( 1.5 "Patrilineal Karbi" 4.5 "Matrilineal Khasi", noticks) title("Loan Default") xtitle(" ")
restore
preserve
*Risky project choice by gender and society*
collapse (mean) meanvar = risky_project (sd) sdvar=risky_project (count) n=risky_project, by(female khasi)
generate hivar = meanvar + invttail(n-1,0.025)*(sdvar / sqrt(n))
generate lowvar = meanvar - invttail(n-1,0.025)*(sdvar / sqrt(n))
gen fk = female+1 if khasi==0
replace fk=female+4 if khasi==1
sort fk
twoway (bar meanvar fk if female==0) (bar meanvar fk if female==1) (rcap hivar lowvar fk),  legend(row(1) order(1 "Male" 2 "Female") ) xlabel( 1.5 "Patrilineal Karbi" 4.5 "Matrilineal Khasi", noticks) title("Risky Project Choice") xtitle(" ")
restore
preserve
*strategic default by gender and society*
collapse (mean) meanvar = strategic_default (sd) sdvar=strategic_default (count) n=strategic_default, by(female khasi)
generate hivar = meanvar + invttail(n-1,0.025)*(sdvar / sqrt(n))
generate lowvar = meanvar - invttail(n-1,0.025)*(sdvar / sqrt(n))
gen fk = female+1 if khasi==0
replace fk=female+4 if khasi==1
sort fk
twoway (bar meanvar fk if female==0) (bar meanvar fk if female==1) (rcap hivar lowvar fk), yscale(off) legend(row(1) order(1 "Male" 2 "Female") ) xlabel( 1.5 "Patrilineal Karbi" 4.5 "Matrilineal Khasi", noticks) title("Strategic Default") xtitle(" ")
restore
preserve
*risk behavior by gender and society*
collapse (mean) meanvar = invest_lottery (sd) sdvar=invest_lottery (count) n=invest_lottery, by(female khasi)
generate hivar = meanvar + invttail(n-1,0.025)*(sdvar / sqrt(n))
generate lowvar = meanvar - invttail(n-1,0.025)*(sdvar / sqrt(n))
gen fk = female+1 if khasi==0
replace fk=female+4 if khasi==1
sort fk
twoway (bar meanvar fk if female==0) (bar meanvar fk if female==1) (rcap hivar lowvar fk), yscale(off) legend(row(1) order(1 "Male" 2 "Female") ) xlabel( 1.5 "Patrilineal Karbi" 4.5 "Matrilineal Khasi", noticks) title("Investment in Risky Lottery") xtitle(" ")
restore
preserve
*past experience with microfinance by gender and society*
collapse (mean) meanvar = experienced (sd) sdvar=experienced (count) n=experienced, by(female khasi)
generate hivar = meanvar + invttail(n-1,0.025)*(sdvar / sqrt(n))
generate lowvar = meanvar - invttail(n-1,0.025)*(sdvar / sqrt(n))
gen fk = female+1 if khasi==0
replace fk=female+4 if khasi==1
sort fk
twoway (bar meanvar fk if female==0) (bar meanvar fk if female==1) (rcap hivar lowvar fk), yscale(off) legend(row(1) order(1 "Male" 2 "Female") ) xlabel( 1.5 "Patrilineal Karbi" 4.5 "Matrilineal Khasi", noticks) title("Experience with Microfinance") xtitle(" ")
restore
preserve

/*Khasi Bengali*/
 use "updated khasi bengali new data set.dta", replace
 preserve
*Loan Default by gender and society*
collapse (mean) meanvar = group_default (sd) sdvar=group_default (count) n=group_default, by(female khasi)
generate hivar = meanvar + invttail(n-1,0.025)*(sdvar / sqrt(n))
generate lowvar = meanvar - invttail(n-1,0.025)*(sdvar / sqrt(n))
gen fk = female+1 if khasi==0
replace fk=female+4 if khasi==1
sort fk
twoway (bar meanvar fk if female==0) (bar meanvar fk if female==1) (rcap hivar lowvar fk), yscale(off) legend(row(1) order(1 "Male" 2 "Female") ) xlabel( 1.5 "Patrilineal Bengali" 4.5 "Matrilineal Khasi", noticks) title("Loan Default") xtitle(" ")
restore
preserve
*Risky project choice by gender and society*
collapse (mean) meanvar = risky_project (sd) sdvar=risky_project (count) n=risky_project, by(female khasi)
generate hivar = meanvar + invttail(n-1,0.025)*(sdvar / sqrt(n))
generate lowvar = meanvar - invttail(n-1,0.025)*(sdvar / sqrt(n))
gen fk = female+1 if khasi==0
replace fk=female+4 if khasi==1
sort fk
twoway (bar meanvar fk if female==0) (bar meanvar fk if female==1) (rcap hivar lowvar fk), yscale(off) legend(row(1) order(1 "Male" 2 "Female") ) xlabel( 1.5 "Patrilineal Bengali" 4.5 "Matrilineal Khasi", noticks) title("Risky Project Choice") xtitle(" ")
restore
preserve
*strategic default by gender and society*
collapse (mean) meanvar = strategic_default (sd) sdvar=strategic_default (count) n=strategic_default, by(female khasi)
generate hivar = meanvar + invttail(n-1,0.025)*(sdvar / sqrt(n))
generate lowvar = meanvar - invttail(n-1,0.025)*(sdvar / sqrt(n))
gen fk = female+1 if khasi==0
replace fk=female+4 if khasi==1
sort fk
twoway (bar meanvar fk if female==0) (bar meanvar fk if female==1) (rcap hivar lowvar fk), yscale(off) legend(row(1) order(1 "Male" 2 "Female") ) xlabel( 1.5 "Patrilineal Bengali" 4.5 "Matrilineal Khasi", noticks) title("Strategic Default") xtitle(" ")
restore
preserve
*risk behavior by gender and society*
collapse (mean) meanvar = invest_lottery (sd) sdvar=invest_lottery (count) n=invest_lottery, by(female khasi)
generate hivar = meanvar + invttail(n-1,0.025)*(sdvar / sqrt(n))
generate lowvar = meanvar - invttail(n-1,0.025)*(sdvar / sqrt(n))
gen fk = female+1 if khasi==0
replace fk=female+4 if khasi==1
sort fk
twoway (bar meanvar fk if female==0) (bar meanvar fk if female==1) (rcap hivar lowvar fk), yscale(off) legend(row(1) order(1 "Male" 2 "Female") ) xlabel( 1.5 "Patrilineal Bengali" 4.5 "Matrilineal Khasi", noticks) title("Investment in Risky Lottery") xtitle(" ")
restore
preserve
