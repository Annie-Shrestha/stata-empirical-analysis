
/*######################### Mid - Day Meal #################################*
                      
Project       : MID DAY MEAL
Author        : Annie Shrestha
Purpose       : Measuring the relationship between mid day meal and educational
                outcomes
Notes         : 
		     
Last update   : 22 Feb 2023

*******************************************************************************/

********************************* Using Data **********************************


********************************* Installing Commands **************************

**ssc install jb
ssc install psmatch2
*net install st0026_2
ssc insatll outreg2

*###############################################################################
			  *				Labeling the variables
*###############################################################################
label var MDM "Exposure to MDM"
label define MDM 0 "Not exposed to MDM" 1 "Exposed to MDM"
label val MDM MDM

label var Age "Age of the student"

label var Female "Wether the student is a male or a female"

label var BMI "Body Max Index"

label var Attendance "Attendance in School"

label var EnglishReading "Score in english reading"

label var SecondLanguageReading "Score in SecondLanguageReading"

label var CombinedReading "Combined reading score (english + second language)"

label var NumberRecognition "Score in Number Recognition"

label var CombinedSubtraction "Score in subtraction"

label var CombinedMultiplication "Score in Multiplication"

label var CombinedDivision "Score in Division"

label var MathsTest "Combined maths score (sub, multi, division)"

label var DailyTask "Score in daily task"

label var SimpleCalculation "Score in Simple Calculation"

label var FinancialCalculation "Score in Financial Calculation"

label var ParentAge "Parent's Age"

label var ParentsEQ "Parent's emotional quotient"

label var FamilyInc "Family Income"

label var Tiffin "If student carries tiffin to school"

label var SchoolExams "Student's score in school maths test"

label var NOC "Number of children in family"

label var Siblings "If student has siblings"

label var MO "Mother's occupation"

label var NumberofSchoolYears "Student's number of years of schooling"

label define cat4E 0 "No questions answered correctly"  ///
1 "One question answered correctly" 2 "Two questions answered correctly" ///
3 "Three questions answered correctly" 4 "Four questions answered correctly" ///
5 "Five questions answered correctly"
label values EnglishReading cat4E

label define cat4S 0 "No questions answered correctly" ///
 1 "One question answered correctly" 2 "Two questions answered correctly" ///
 3 "Three questions answered correctly" 4 "Four questions answered correctly"///
 5 "Five questions answered correctly"
label values SecondLanguageReading cat4S

label define cat4C 2 "Two questions answered correctly" ///
3 "Three questions answered correctly" 4 "Four questions answered correctly" ///
5 "Five questions answered correctly" 6 "Six questions answered correctly" ///
7 "Seven questions answered" 8 "Eight questions answered correctly" ///
9 "Nine questions answered" 10 "Ten questions answered correctly"
label values CombinedReading cat4C

label define cat4NR 0 "Doesn't Know"  1 "Can recognize 1 digit number" ///
2 "Can recognize 2-digit numbers"
label values NumberRecognition cat4NR

label define cat4CS 0 "No questions answered correctly" ///
1 "One question answered correctly" 2 "Two questions answered correctly" 
label values CombinedSubtraction cat4CS

label define cat4CMx 0 "No questions answered correctly" ///
1 "One question answered correctly" 2 "Two questions answered correctly" 
label values CombinedMultiplication cat4CMx

label define cat4CD 0 "No questions answered correctly" ///
1 "One question answered correctly" 2 "Two questions answered correctly" 
label values CombinedDivision cat4CD

label define cat4MT 0 "No questions answered correctly" ///
1 "One question answered correctly" 2 "Two questions answered correctly" 
label values CombinedDivision cat4CD

label define cat4Ma 0 "No questions answered correctly" ///
3 "Three questions answered correctly" 2 "Two questions answered correctly" //
4 "Four questions answered correctly" 5 "Five questions answered correctly" ///
6 "Six questions answered correctly"
label values MathsTest cat4Ma

label define cat4Dt 0 "No questions answered correctly" ///
1 "One question answered correctly" 2 "Two questions answered correctly" ///
4 "Four questions answered correctly" 5 "Five questions answered correctly" 
label values DailyTask cat4Dt

label define cat4Fc 0 "No questions answered correctly" ///
1 "One question answered correctly" 2 "Two questions answered correctly" ///
3 "Three questions answered correctly" 4 "Four questions answered correctly" 
label values FinancialCalculation cat4Fc

label define cat4SC 2 "Two questions answered correctly" ///
 3 "Three questions answered correctly" 4 "Four questions answered correctly" ///
 5 "Five questions answered correctly" 6 "Six questions answered correctly" ///
 7 "Seven questions answered" 8 "Eight questions answered correctly" ///
 9 "Nine questions answered" 10 "Ten questions answered correctly" ///
 11 "Eleven questions answered correctly" 12 "Twelve questions answered correctly"
label values SimpleCalculation cat4SC

order SchoolNumber, before (MDM)
order CombinedSubtraction CombinedMultiplication CombinedDivision MathsTest NumberRecognition ///
DailyTask SimpleCalculation FinancialCalculation, before(EnglishReading)
order  SchoolExams NumberofSchoolYears Attendance BMI, before (ParentAge)
*###############################################################################
              *                 SUMMARY STATS
*###############################################################################

 by MDM, sort : summarize Age Female BMI Attendance NumberRecognition  ///
 CombinedSubtraction CombinedMultiplication CombinedDivision   ///
 MathsTest DailyTask SimpleCalculation FinancialCalculation
 
 ** Tabulation for Y variables 
 asdoc tabulate NumberRecognition MDM
 asdoc tabulate MathsTest MDM
 asdoc tabulate CombinedSubtraction MDM
 asdoc tabulate CombinedMultiplication MDM
 asdoc tabulate CombinedDivision MDM
 asdoc tabulate DailyTask MDM
 asdoc tabulate FinancialCalculation MDM
 asdoc tabulate SimpleCalculation MDM
 
 ** sd test- to test variances*
 sdtest Age, by (MDM)
 sdtest BMI,by (MDM)
 sdtest Attendance, by(MDM)
 sdtest EnglishReading, by (MDM)
 sdtest SecondLanguageReading , by (MDM)
 sdtest CombinedReading , by (MDM)
 sdtest NumberRecognition , by (MDM)
 sdtest CombinedSubtraction, by (MDM)
 sdtest CombinedMultiplication , by (MDM)
 sdtest CombinedDivision , by (MDM)
 sdtest MathsTest , by (MDM)
 sdtest DailyTask , by (MDM)
 sdtest FinancialCalculation , by (MDM)
 sdtest SimpleCalculation , by (MDM)
 
 **t test with unequal variance for variables that are significant in SD test**
 ttest Age, by (MDM) unequal
 ttest NumberRecognition, by (MDM) unequal
 ttest CombinedSubtraction, by (MDM) unequal
 ttest CombinedDivision , by (MDM) unequal
 ttest MathsTest , by (MDM) unequal
 **t test with unequal variance for variables that are insignificant in SD test**
 ttest BMI, by (MDM)
 ttest Attendance, by (MDM)
 ttest EnglishReading , by (MDM)
 ttest SecondLanguageReading , by (MDM)
 ttest CombinedReading , by (MDM)
 ttest CombinedMultiplication , by (MDM)
 ttest DailyTask , by (MDM)
 ttest FinancialCalculation , by (MDM)
 ttest SimpleCalculation , by (MDM)
 
 ***checking for multicollinearity
 *vif
 correlate
 ***Normality****
 regress MathsTest MDM Age Female BMI Attendance SchoolExams NOC MO ///
 NumberofSchoolYears FamilyInc ParentsEQ 
 predict resid1,residuals
 jb resid1
 *plotting
 kdensity resid1,normal
 pnorm resid1
 qnorm resid1
   
 *<><><><><><><><><><><><><><><><><><><><><><><><><<><><><><><><><><><><><><><
 *<><><><><><><><><><>><><> UNMATCHED DATA <><><><><<>><<><><><><><><><>>>><><*
 *<><><><><><><><><><><><><><><><><><><><><><><><><<><><><><><><><><><><><><><
  
 ********************** MATHS TEST (COMBINED SCORE) **************************
 ologit MathsTest MDM Age Female BMI Attendance SchoolExams NOC i.MO ///
 NumberofSchoolYears FamilyInc i.ParentsEQ,vce(robust) or
 
 
 ologit MathsTest MDM Age Female BMI Attendance SchoolExams NOC i.MO ///
 NumberofSchoolYears FamilyInc i.ParentsEQ,vce(robust) 
 margins, dydx(*)post

 *************************** COMBINED SUBTRACTION ****************************
 ologit CombinedSubtraction MDM Age Female BMI Attendance SchoolExams NOC i.MO ///
 NumberofSchoolYears FamilyInc i.ParentsEQ,vce( robust) or
 
 ologit CombinedSubtraction MDM Age Female BMI Attendance SchoolExams NOC i.MO ///
 NumberofSchoolYears FamilyInc i.ParentsEQ,vce( robust)
 margins, dydx(*)post

 ***************************** COMBINED DIVISION ******************************
 ologit CombinedDivision MDM Age Female BMI Attendance SchoolExams NOC i.MO ///
 NumberofSchoolYears FamilyInc i.ParentsEQ,vce( robust) or
 
 ologit CombinedDivision MDM Age Female BMI Attendance SchoolExams NOC i.MO ///
 NumberofSchoolYears FamilyInc i.ParentsEQ,vce( robust) 
 margins, dydx(*)post

 ***************************** COMBINED MULTIPLICATION *************************
 ologit CombinedMultiplication MDM Age Female BMI Attendance SchoolExams NOC ///
 i.MO NumberofSchoolYears FamilyInc i.ParentsEQ,  vce(robust) or
 
 ologit CombinedMultiplication MDM Age Female BMI Attendance SchoolExams NOC ///
 i.MO NumberofSchoolYears FamilyInc i.ParentsEQ,  vce(robust)  
 margins, dydx(*)post

 ***************************** NUMBER RECOGNITION ****************************
 ologit NumberRecognition MDM Age Female BMI Attendance SchoolExams NOC i.MO ///
 NumberofSchoolYears FamilyInc i.ParentsEQ,vce(robust) or
 
 ologit NumberRecognition MDM Age Female BMI Attendance SchoolExams NOC i.MO ///
 NumberofSchoolYears FamilyInc i.ParentsEQ,vce(robust)
 margins, dydx(*)post

 ***************************** FINANCIAL CALCULATION **************************
 ologit FinancialCalculation MDM Age Female BMI Attendance SchoolExams NOC i.MO ///
 NumberofSchoolYears FamilyInc i.ParentsEQ, vce(robust) or
 
 ologit FinancialCalculation MDM Age Female BMI Attendance SchoolExams NOC i.MO ///
 NumberofSchoolYears FamilyInc i.ParentsEQ, vce(robust) 
 margins, dydx(*)post

 ********************************* DAILY TASK *********************************
 ologit DailyTask MDM Age Female BMI Attendance SchoolExams NOC i.MO ///
 NumberofSchoolYears FamilyInc i.ParentsEQ, vce(robust) or
 
 ologit DailyTask MDM Age Female BMI Attendance SchoolExams NOC i.MO ///
 NumberofSchoolYears FamilyInc i.ParentsEQ, vce(robust) 
 margins, dydx(*)post

 ******************************** SIMPLE CALCULATION ***************************
 ologit SimpleCalculation MDM Age Female BMI Attendance SchoolExams NOC i.MO ///
 NumberofSchoolYears FamilyInc i.ParentsEQ, vce (robust) or
 
 ologit SimpleCalculation MDM Age Female BMI Attendance SchoolExams NOC i.MO ///
 NumberofSchoolYears FamilyInc i.ParentsEQ, vce (robust) 
 margins, dydx(*)post
 
  *<><><><><><><><><><><><><><><><><><><><><><><><><<><><><><><><><><><><><><><
 *<><><><><><><><><><>><><> RADIUS CALIPER  <><><><><<>><<><><><><><><><>>>>><*
 *<><><><><><><><><><><><><><><><><><><><><><><><><<><><><><><><><><><><><><><

 *##############################################################################
              *                MATHS TEST (COMBINED SCORE)
 *##############################################################################
 
 ********************************** MATCHING *********************************
 
 logit MDM Female BMI Attendance SchoolExams NOC FamilyInc
 predict pscore
 su pscore
 local caliper = sqrt(r(sd))/4
 display `caliper' // .10267865
 
 set seed 123456
 gen random_order = uniform()
 sort random_order
 
 psmatch2 MDM Female BMI Attendance NOC SchoolExams FamilyInc, ///
 outcome(MathsTest) radius caliper(.10267865) logit ate common
 
 pstest, both

 *********************************** OLOGIT ***********************************
 ologit MathsTest MDM Age Female BMI Attendance SchoolExams NOC i.MO NumberofSchoolYears ///
 FamilyInc i.ParentsEQ [pweight=_weight], vce(robust) or
 
 ologit MathsTest MDM [pweight=_weight], vce(robust) or

 ologit MathsTest MDM Age Female BMI Attendance SchoolExams NOC i.MO NumberofSchoolYears ///
 FamilyInc i.ParentsEQ[pweight=_weight], vce(robust) 
 margins, dydx(*)post
 
 drop random_order - _MathsTest 
 
 *##############################################################################
              *                   DAILY TASK 
 *##############################################################################
 
 ********************************** MATCHING *********************************
 
 logit MDM Female BMI Attendance SchoolExams NOC FamilyInc
 predict pscore
 su pscore
 local caliper = sqrt(r(sd))/4
 display `caliper' // .10267865
 
 set seed 123456
 gen random_order = uniform()
 sort random_order
 
 psmatch2 MDM Female BMI Attendance NOC SchoolExams FamilyInc, ///
 outcome(DailyTask) radius caliper(.10267865) logit ate common
 
 pstest, both
 
 *********************************** OLOGIT ***********************************
 ologit DailyTask MDM Age Female BMI Attendance SchoolExams NOC i.MO NumberofSchoolYears ///
 FamilyInc i.ParentsEQ [pweight=_weight], vce(robust) or
 
 ologit DailyTask MDM [pweight=_weight], vce(robust) or

 ologit DailyTask MDM Age Female BMI Attendance SchoolExams NOC i.MO NumberofSchoolYears ///
 FamilyInc i.ParentsEQ[pweight=_weight], vce(robust) 
 margins, dydx(*)post
 
 drop random_order - _DailyTask
 
 *##############################################################################
              *               FINANCIAL CALCULATION
 *##############################################################################
 
 ********************************** MATCHING *********************************
 
 logit MDM Female BMI Attendance SchoolExams NOC FamilyInc
 predict pscore
 su pscore
 local caliper = sqrt(r(sd))/4
 display `caliper' // .10267865
 
 set seed 123456
 gen random_order = uniform()
 sort random_order
 
 psmatch2 MDM Female BMI Attendance NOC SchoolExams FamilyInc, ///
 outcome( FinancialCalculation) radius caliper(.10267865) logit ate common
 
 pstest, both
 
 *********************************** OLOGIT ***********************************
 ologit FinancialCalculation MDM Age Female BMI Attendance SchoolExams NOC i.MO NumberofSchoolYears ///
 FamilyInc i.ParentsEQ[pweight=_weight], vce(robust) or
  
 ologit FinancialCalculation MDM Age Female BMI Attendance SchoolExams NOC i.MO NumberofSchoolYears ///
 FamilyInc i.ParentsEQ[pweight=_weight], vce(robust) 
 margins, dydx(*)post
 
 drop random_order - _FinancialCalculation
 
 *##############################################################################
              *              SIMPLE CALCULATION
 *##############################################################################
 
 ********************************** MATCHING *********************************
 
 logit MDM Female BMI Attendance SchoolExams NOC FamilyInc
 predict pscore
 su pscore
 local caliper = sqrt(r(sd))/4
 display `caliper' // .10267865
 
 set seed 123456
 gen random_order = uniform()
 sort random_order
 
 psmatch2 MDM Female BMI Attendance NOC SchoolExams FamilyInc, ///
 outcome(SimpleCalculation) radius caliper(.10267865) logit ate common
 
 pstest, both
 
 *********************************** OLOGIT ***********************************
 ologit SimpleCalculation MDM Age Female BMI Attendance SchoolExams NOC i.MO NumberofSchoolYears ///
 FamilyInc i.ParentsEQ [pweight=_weight], vce(robust) or
 
 ologit SimpleCalculation MDM Age Female BMI Attendance SchoolExams NOC i.MO NumberofSchoolYears ///
 FamilyInc i.ParentsEQ [pweight=_weight], vce(robust) 
 margins, dydx(*)post
 
 drop random_order - _SimpleCalculation

 *##############################################################################
              *              NUMBER RECOGNITION
 *##############################################################################
 
 ********************************** MATCHING *********************************
 
 logit MDM Female BMI Attendance SchoolExams NOC FamilyInc
 predict pscore
 su pscore
 local caliper = sqrt(r(sd))/4
 display `caliper' // .10267865
 
 set seed 123456
 gen random_order = uniform()
 sort random_order
 
 psmatch2 MDM Female BMI Attendance NOC SchoolExams FamilyInc, ///
 outcome(NumberRecognition) radius caliper(.10267865) logit ate common
 
 pstest, both
 
 *********************************** OLOGIT ***********************************
 ologit NumberRecognition MDM Age Female BMI Attendance SchoolExams NOC i.MO NumberofSchoolYears ///
 FamilyInc i.ParentsEQ [pweight=_weight], vce(robust) or
 
 ologit NumberRecognition MDM Age Female BMI Attendance SchoolExams NOC i.MO NumberofSchoolYears ///
 FamilyInc i.ParentsEQ [pweight=_weight], vce(robust) 
 margins, dydx(*)post
 
 drop random_order - _NumberRecognition
 
 *##############################################################################
              *              SIMPLE CALCULATION
 *##############################################################################
 
 ********************************** MATCHING *********************************

 logit MDM Female BMI Attendance SchoolExams NOC FamilyInc
 predict pscore
 su pscore
 local caliper = sqrt(r(sd))/4
 display `caliper' // .10267865
 
 set seed 123456
 gen random_order = uniform()
 sort random_order
 
 psmatch2 MDM Female BMI Attendance NOC SchoolExams FamilyInc, ///
 outcome(SimpleCalculation) radius caliper(.10267865) logit ate common
 
 pstest, both
 
 *********************************** OLOGIT ***********************************
 ologit NumberRecognition MDM Age Female BMI Attendance SchoolExams NOC i.MO NumberofSchoolYears ///
 FamilyInc i.ParentsEQ [pweight=_weight], vce(robust) or

 ologit NumberRecognition MDM Age Female BMI Attendance SchoolExams NOC i.MO NumberofSchoolYears ///
 FamilyInc i.ParentsEQ [pweight=_weight], vce(robust) 
 margins, dydx(*)post
 
 drop random_order - _SimpleCalculation
 
 *<><><><><><><><><><><><><><><><><><><><><><><><><<><><><><><><><><><><><><><
 *<><><><><><><><><><>><><> RADIUS CALIPER WITHOUT BMI ><<><><><><><><><>>>>><*
 *<><><><><><><><><><><><><><><><><><><><><><><><><<><><><><><><><><><><><><><

 *##############################################################################
              *                MATHS TEST (COMBINED SCORE)
 *##############################################################################
 
 ********************************** MATCHING *********************************

 
 set seed 123456
 gen random_order = uniform()
 sort random_order
 
 psmatch2 MDM Female Attendance NOC SchoolExams FamilyInc, ///
 outcome(MathsTest) radius caliper(.10267865) logit ate common
 
 pstest, both

 *********************************** OLOGIT ***********************************
 ologit MathsTest MDM Age Female Attendance SchoolExams NOC i.MO NumberofSchoolYears ///
 FamilyInc i.ParentsEQ [pweight=_weight], vce(robust) or
 
 drop random_order - _MathsTest 

  *##############################################################################
              *                   DAILY TASK 
 *##############################################################################
 
 ********************************** MATCHING *********************************
 
 set seed 123456
 gen random_order = uniform()
 sort random_order
 
 psmatch2 MDM Female Attendance NOC SchoolExams FamilyInc, ///
 outcome(DailyTask) radius caliper(.10267865) logit ate common
 
 pstest, both
 
  *********************************** OLOGIT ***********************************
 ologit DailyTask MDM Age Female Attendance SchoolExams NOC i.MO NumberofSchoolYears ///
 FamilyInc i.ParentsEQ [pweight=_weight], vce(robust) or
 
 drop random_order - _DailyTask

 *##############################################################################
              *               FINANCIAL CALCULATION
 *##############################################################################
 
 ********************************** MATCHING *********************************
 
 set seed 123456
 gen random_order = uniform()
 sort random_order
 
 psmatch2 MDM Female Attendance NOC SchoolExams FamilyInc, ///
 outcome( FinancialCalculation) radius caliper(.10267865) logit ate common
 
 pstest, both
 
  *********************************** OLOGIT ***********************************
 ologit FinancialCalculation MDM Age Female Attendance SchoolExams NOC i.MO NumberofSchoolYears ///
 FamilyInc i.ParentsEQ[pweight=_weight], vce(robust) or
 
 drop random_order - _FinancialCalculation
 
  *##############################################################################
              *              SIMPLE CALCULATION
 *##############################################################################
 
 ********************************** MATCHING *********************************
  
 set seed 123456
 gen random_order = uniform()
 sort random_order
 
 psmatch2 MDM Female Attendance NOC SchoolExams FamilyInc, ///
 outcome(SimpleCalculation) radius caliper(.10267865) logit ate common
 
 pstest, both
 
 *********************************** OLOGIT ***********************************
 ologit SimpleCalculation MDM Age Female Attendance SchoolExams NOC i.MO NumberofSchoolYears ///
 FamilyInc i.ParentsEQ [pweight=_weight], vce(robust) or

 drop random_order - _SimpleCalculation

  *##############################################################################
              *              NUMBER RECOGNITION
 *##############################################################################
 
 ********************************** MATCHING *********************************
 
 set seed 123456
 gen random_order = uniform()
 sort random_order
 
 psmatch2 MDM Female Attendance NOC SchoolExams FamilyInc, ///
 outcome(NumberRecognition) radius caliper(.10267865) logit ate common
 
 pstest, both
 
 *********************************** OLOGIT ***********************************
 ologit NumberRecognition MDM Age Female Attendance SchoolExams NOC i.MO NumberofSchoolYears ///
 FamilyInc i.ParentsEQ [pweight=_weight], vce(robust) or
 
 drop random_order - _NumberRecognition
 
 *<><><><><><><><><><><><><><><><><><><><><><><><><<><><><><><><><><><><><><><
 *<><><><><><><><><><>><><> RADIUS CALIPER WITHout ATTENDANCE <><><><><><><>>>>><*
 *<><><><><><><><><><><><><><><><><><><><><><><><><<><><><><><><><><><><><><><

 *##############################################################################
              *                MATHS TEST (COMBINED SCORE)
 *##############################################################################
 
 ********************************** MATCHING *********************************

 
 set seed 123456
 gen random_order = uniform()
 sort random_order
 
 psmatch2 MDM Female BMI NOC SchoolExams FamilyInc, ///
 outcome(MathsTest) radius caliper(.10267865) logit ate common
 
 pstest, both

 *********************************** OLOGIT ***********************************
 ologit MathsTest MDM Age Female BMI SchoolExams NOC i.MO NumberofSchoolYears ///
 FamilyInc i.ParentsEQ [pweight=_weight], vce(robust) or
 
 drop random_order - _MathsTest 

  *##############################################################################
              *                   DAILY TASK 
 *##############################################################################
 
 ********************************** MATCHING *********************************
 
 set seed 123456
 gen random_order = uniform()
 sort random_order
 
 psmatch2 MDM Female BMI NOC SchoolExams FamilyInc, ///
 outcome(DailyTask) radius caliper(.10267865) logit ate common
 
 pstest, both
 
  *********************************** OLOGIT ***********************************
 ologit DailyTask MDM Age Female BMI SchoolExams NOC i.MO NumberofSchoolYears ///
 FamilyInc i.ParentsEQ [pweight=_weight], vce(robust) or
 
 drop random_order - _DailyTask

 *##############################################################################
              *               FINANCIAL CALCULATION
 *##############################################################################
 
 ********************************** MATCHING *********************************
 
 set seed 123456
 gen random_order = uniform()
 sort random_order
 
 psmatch2 MDM Female BMI NOC SchoolExams FamilyInc, ///
 outcome(FinancialCalculation) radius caliper(.10267865) logit ate common
 
 pstest, both
 
  *********************************** OLOGIT ***********************************
 ologit FinancialCalculation MDM Age Female BMI SchoolExams NOC i.MO NumberofSchoolYears ///
 FamilyInc i.ParentsEQ[pweight=_weight], vce(robust) or
 
 drop random_order - _FinancialCalculation
 
  *##############################################################################
              *              SIMPLE CALCULATION
 *##############################################################################
 
 ********************************** MATCHING *********************************
  
 set seed 123456
 gen random_order = uniform()
 sort random_order
 
 psmatch2 MDM Female BMI NOC SchoolExams FamilyInc, ///
 outcome(SimpleCalculation) radius caliper(.10267865) logit ate common
 
 pstest, both
 
 *********************************** OLOGIT ***********************************
 ologit SimpleCalculation MDM Age Female BMI SchoolExams NOC i.MO NumberofSchoolYears ///
 FamilyInc i.ParentsEQ [pweight=_weight], vce(robust) or

 drop random_order - _SimpleCalculation

  *##############################################################################
              *              NUMBER RECOGNITION
 *##############################################################################
 
 ********************************** MATCHING *********************************
 
 set seed 123456
 gen random_order = uniform()
 sort random_order
 
 psmatch2 MDM Female BMI NOC SchoolExams FamilyInc, ///
 outcome(NumberRecognition) radius caliper(.10267865) logit ate common
 
 pstest, both
 
 *********************************** OLOGIT ***********************************
 ologit NumberRecognition MDM Age Female BMI SchoolExams NOC i.MO NumberofSchoolYears ///
 FamilyInc i.ParentsEQ [pweight=_weight], vce(robust) or
 
 drop random_order - _NumberRecognition


 *<><><><><><><><><><><><><><><><><><><><><><><><><<><><><><><><><><><><><><><
 *<><><><><><><><><><>><><> CALIPER MATCHING <><><><><<>><<><><><><><><><>>>>><*
 *<><><><><><><><><><><><><><><><><><><><><><><><><<><><><><><><><><><><><><><

 *##############################################################################
              *                MATHS TEST (COMBINED SCORE)
 *##############################################################################
 
 ********************************** MATCHING *********************************
 
 //Calculating pscore and caliper value (only required in calipe & radius caliper)
 logit MDM Female BMI Attendance SchoolExams NOC FamilyInc
 predict pscore
 su pscore
 local caliper = sqrt(r(sd))/4
 display `caliper' // .10267865
 
 //To fix the order of matching
 set seed 123456
 gen random_order = uniform()
 sort random_order
 
 //Matching
 psmatch2 MDM Female BMI Attendance NOC SchoolExams FamilyInc, ///
 outcome(MathsTest) caliper(.10267865) logit ate common
 
 //Balance Test
 pstest, both

 *********************************** OLOGIT ***********************************
 //Ordered Logit for Odds Ratios
 ologit MathsTest MDM Age Female BMI Attendance SchoolExams NOC i.MO NumberofSchoolYears ///
 FamilyInc i.ParentsEQ[fweight=_weight], vce(robust) or
 
 //Ordered logit for marginal coefficients
 ologit MathsTest MDM Age Female BMI Attendance SchoolExams NOC i.MO NumberofSchoolYears ///
 FamilyInc i.ParentsEQ[fweight=_weight], vce(robust) 
 margins, dydx(*)post
 
 drop random_order - _pdif
 
 *##############################################################################
              *                   DAILY TASK 
 *##############################################################################
 
 ********************************** MATCHING *********************************
 
 logit MDM Female BMI Attendance SchoolExams NOC FamilyInc
 predict pscore
 su pscore
 local caliper = sqrt(r(sd))/4
 display `caliper' // .10267865
 
 set seed 123456
 gen random_order = uniform()
 sort random_order
 
 psmatch2 MDM Female BMI Attendance NOC SchoolExams FamilyInc, ///
 outcome(DailyTask) caliper(.10267865) logit ate common
 
 pstest, both
 
 *********************************** OLOGIT ***********************************
 ologit DailyTask MDM Age Female BMI Attendance SchoolExams NOC i.MO NumberofSchoolYears ///
 FamilyInc i.ParentsEQ[fweight=_weight], vce(robust) or

 ologit DailyTask MDM Age Female BMI Attendance SchoolExams NOC i.MO NumberofSchoolYears ///
 FamilyInc i.ParentsEQ[fweight=_weight], vce(robust) 
 margins, dydx(*)post
 
 drop random_order - _pdif

 *##############################################################################
              *               FINANCIAL CALCULATION
 *##############################################################################
 
 ********************************** MATCHING *********************************
 
 logit MDM Female BMI Attendance SchoolExams NOC FamilyInc
 predict pscore
 su pscore
 local caliper = sqrt(r(sd))/4
 display `caliper' // .10267865
 
 set seed 123456
 gen random_order = uniform()
 sort random_order
 
 psmatch2 MDM Female BMI Attendance NOC SchoolExams FamilyInc, ///
 outcome( FinancialCalculation) caliper(.10267865) logit ate common
 
 pstest, both
 
 *********************************** OLOGIT ***********************************
 ologit FinancialCalculation MDM Age Female BMI Attendance SchoolExams NOC i.MO NumberofSchoolYears ///
 FamilyInc i.ParentsEQ[fweight=_weight], vce(robust) or

 ologit FinancialCalculation MDM Age Female BMI Attendance SchoolExams NOC i.MO NumberofSchoolYears ///
 FamilyInc i.ParentsEQ[fweight=_weight], vce(robust) 
 margins, dydx(*)post
 
 drop random_order - _pdif
 
 *##############################################################################
              *              SIMPLE CALCULATION
 *##############################################################################
 
 ********************************** MATCHING *********************************
 
 logit MDM Female BMI Attendance SchoolExams NOC FamilyInc
 predict pscore
 su pscore
 local caliper = sqrt(r(sd))/4
 display `caliper' // .10267865
 
 set seed 123456
 gen random_order = uniform()
 sort random_order
 
 psmatch2 MDM Female BMI Attendance NOC SchoolExams FamilyInc, ///
 outcome(SimpleCalculation) caliper(.10267865) logit ate common
 
 pstest, both
 
 *********************************** OLOGIT ***********************************
 ologit SimpleCalculation MDM Age Female BMI Attendance SchoolExams NOC i.MO NumberofSchoolYears ///
 FamilyInc i.ParentsEQ[fweight=_weight], vce(robust) or

 ologit SimpleCalculation MDM Age Female BMI Attendance SchoolExams NOC i.MO NumberofSchoolYears ///
 FamilyInc i.ParentsEQ[fweight=_weight], vce(robust) 
 margins, dydx(*)post
 
 drop random_order - _pdif

 *##############################################################################
              *              NUMBER RECOGNITION
 *##############################################################################
 
 ********************************** MATCHING *********************************
 
 logit MDM Female BMI Attendance SchoolExams NOC FamilyInc
 predict pscore
 su pscore
 local caliper = sqrt(r(sd))/4
 display `caliper' // .10267865
 
 set seed 123456
 gen random_order = uniform()
 sort random_order
 
 psmatch2 MDM Female BMI Attendance NOC SchoolExams FamilyInc, ///
 outcome(NumberRecognition) caliper(.10267865) logit ate common
 
 pstest, both
 
 *********************************** OLOGIT ***********************************
 ologit NumberRecognition MDM Age Female BMI Attendance SchoolExams NOC i.MO NumberofSchoolYears ///
 FamilyInc i.ParentsEQ[fweight=_weight], vce(robust) or

 ologit NumberRecognition MDM Age Female BMI Attendance SchoolExams NOC i.MO NumberofSchoolYears ///
 FamilyInc i.ParentsEQ[fweight=_weight], vce(robust) 
 margins, dydx(*)post
 
 drop random_order - _pdif

 
 *<><><><><><><><><><><><><><><><><><><><><><><><><<><><><><><><><><><><><><><
 *<><><><><><><><><><>><><><><><><> KERNEL  <><><><><<>><<><><><><><><><>>>>><*
 *<><><><><><><><><><><><><><><><><><><><><><><><><<><><><><><><><><><><><><><

 *##############################################################################
              *                MATHS TEST (COMBINED SCORE)
 *##############################################################################
 
 ********************************** MATCHING *********************************
  
 set seed 123456
 gen random_order = uniform()
 sort random_order
 
 psmatch2 MDM Female BMI Attendance NOC SchoolExams FamilyInc, ///
 outcome(MathsTest) kernel logit ate common
 
 pstest, both

 *********************************** OLOGIT ***********************************
 ologit MathsTest MDM Age Female BMI Attendance SchoolExams NOC i.MO NumberofSchoolYears ///
 FamilyInc i.ParentsEQ [pweight=_weight], vce(robust) or

 ologit MathsTest MDM Age Female BMI Attendance SchoolExams NOC i.MO NumberofSchoolYears ///
 FamilyInc i.ParentsEQ[pweight=_weight], vce(robust) 
 margins, dydx(*)post
 
 drop random_order - _MathsTest 
 
 *##############################################################################
              *                   DAILY TASK 
 *##############################################################################
 
 ********************************** MATCHING *********************************
 
 set seed 123456
 gen random_order = uniform()
 sort random_order
 
 psmatch2 MDM Female BMI Attendance NOC SchoolExams FamilyInc, ///
 outcome(DailyTask) kernel logit ate common
 
 pstest, both
 
 *********************************** OLOGIT ***********************************
 ologit DailyTask MDM Age Female BMI Attendance SchoolExams NOC i.MO NumberofSchoolYears ///
 FamilyInc i.ParentsEQ [pweight=_weight], vce(robust) or

 ologit DailyTask MDM Age Female BMI Attendance SchoolExams NOC i.MO NumberofSchoolYears ///
 FamilyInc i.ParentsEQ[pweight=_weight], vce(robust) 
 margins, dydx(*)post
 
 drop random_order - _DailyTask
 
 *##############################################################################
              *               FINANCIAL CALCULATION
 *##############################################################################
 
 ********************************** MATCHING *********************************
 
 set seed 123456
 gen random_order = uniform()
 sort random_order
 
 psmatch2 MDM Female BMI Attendance NOC SchoolExams FamilyInc, ///
 outcome( FinancialCalculation) kernel logit ate common
 
 pstest, both
 
 *********************************** OLOGIT ***********************************
 ologit FinancialCalculation MDM Age Female BMI Attendance SchoolExams NOC i.MO NumberofSchoolYears ///
 FamilyInc i.ParentsEQ [pweight=_weight], vce(robust) or

 ologit FinancialCalculation MDM Age Female BMI Attendance SchoolExams NOC i.MO NumberofSchoolYears ///
 FamilyInc i.ParentsEQ [pweight=_weight], vce(robust) 
 margins, dydx(*)post
 
 drop random_order - _FinancialCalculation
 
 *##############################################################################
              *              SIMPLE CALCULATION
 *##############################################################################
 
 ********************************** MATCHING *********************************
  
 set seed 123456
 gen random_order = uniform()
 sort random_order
 
 psmatch2 MDM Female BMI Attendance NOC SchoolExams FamilyInc, ///
 outcome(SimpleCalculation) kernel logit ate common
 
 pstest, both
 
 *********************************** OLOGIT ***********************************
 ologit SimpleCalculation MDM Age Female BMI Attendance SchoolExams NOC i.MO NumberofSchoolYears ///
 FamilyInc i.ParentsEQ [pweight=_weight], vce(robust) or

 ologit SimpleCalculation MDM Age Female BMI Attendance SchoolExams NOC i.MO NumberofSchoolYears ///
 FamilyInc i.ParentsEQ [pweight=_weight], vce(robust) 
 margins, dydx(*)post
 
 drop random_order - _SimpleCalculation

 *##############################################################################
              *              NUMBER RECOGNITION
 *##############################################################################
 
 ********************************** MATCHING *********************************
 
 set seed 123456
 gen random_order = uniform()
 sort random_order
 
 psmatch2 MDM Female BMI Attendance NOC SchoolExams FamilyInc, ///
 outcome(NumberRecognition) kernel logit ate common
 
 pstest, both
 
 *********************************** OLOGIT ***********************************
 ologit NumberRecognition MDM Age Female BMI Attendance SchoolExams NOC i.MO NumberofSchoolYears ///
 FamilyInc i.ParentsEQ [pweight=_weight], vce(robust) or

 ologit NumberRecognition MDM Age Female BMI Attendance SchoolExams NOC i.MO NumberofSchoolYears ///
 FamilyInc i.ParentsEQ [pweight=_weight], vce(robust) 
 margins, dydx(*)post
 
 drop random_order - _NumberRecognition


 
 *<><><><><><><><><><><><><><><><><><><><><><><><><<><><><><><><><><><><><><><
 *<><><><><><><><><><>><><> NEAREST NEIGHBOR <><><><><<>><<><><><><><><><>>>>><*
 *<><><><><><><><><><><><><><><><><><><><><><><><><<><><><><><><><><><><><><><

 *##############################################################################
              *                MATHS TEST (COMBINED SCORE)
 *##############################################################################
 
 ********************************** MATCHING *********************************
  
 set seed 123456
 gen random_order = uniform()
 sort random_order
 
 psmatch2 MDM Female BMI Attendance NOC SchoolExams FamilyInc, ///
 outcome(MathsTest) n(5) logit ate common
 
 pstest, both

 *********************************** OLOGIT ***********************************
 ologit MathsTest MDM Age Female BMI Attendance SchoolExams NOC i.MO NumberofSchoolYears ///
 FamilyInc i.ParentsEQ [pweight=_weight], vce(robust) or

 ologit MathsTest MDM Age Female BMI Attendance SchoolExams NOC i.MO NumberofSchoolYears ///
 FamilyInc i.ParentsEQ[pweight=_weight], vce(robust) 
 margins, dydx(*)post
 
 drop random_order - _pdif
 
 *##############################################################################
              *                   DAILY TASK 
 *##############################################################################
 
 ********************************** MATCHING *********************************
  
 set seed 123456
 gen random_order = uniform()
 sort random_order
 
 psmatch2 MDM Female BMI Attendance NOC SchoolExams FamilyInc, ///
 outcome(DailyTask) n(5) logit ate common
 
 pstest, both
 
 *********************************** OLOGIT ***********************************
 ologit DailyTask MDM Age Female BMI Attendance SchoolExams NOC i.MO NumberofSchoolYears ///
 FamilyInc i.ParentsEQ[pweight=_weight], vce(robust) or

 ologit DailyTask MDM Age Female BMI Attendance SchoolExams NOC i.MO NumberofSchoolYears ///
 FamilyInc i.ParentsEQ[pweight=_weight], vce(robust) 
 margins, dydx(*)post
 
 drop random_order - _pdif

 *##############################################################################
              *               FINANCIAL CALCULATION
 *##############################################################################
 
 ********************************** MATCHING *********************************
 
 set seed 123456
 gen random_order = uniform()
 sort random_order
 
 psmatch2 MDM Female BMI Attendance NOC SchoolExams FamilyInc, ///
 outcome( FinancialCalculation) n(5) logit ate common
 
 pstest, both
 
 *********************************** OLOGIT ***********************************
 ologit FinancialCalculation MDM Age Female BMI Attendance SchoolExams NOC i.MO NumberofSchoolYears ///
 FamilyInc i.ParentsEQ[pweight=_weight], vce(robust) or

 ologit FinancialCalculation MDM Age Female BMI Attendance SchoolExams NOC i.MO NumberofSchoolYears ///
 FamilyInc i.ParentsEQ[pweight=_weight], vce(robust) 
 margins, dydx(*)post
 
 drop random_order - _pdif
 
 *##############################################################################
              *              SIMPLE CALCULATION
 *##############################################################################
 
 ********************************** MATCHING *********************************

 set seed 123456
 gen random_order = uniform()
 sort random_order
 
 psmatch2 MDM Female BMI Attendance NOC SchoolExams FamilyInc, ///
 outcome(SimpleCalculation) n(5) logit ate common
 
 pstest, both
 
 *********************************** OLOGIT ***********************************
 ologit SimpleCalculation MDM Age Female BMI Attendance SchoolExams NOC i.MO NumberofSchoolYears ///
 FamilyInc i.ParentsEQ[pweight=_weight], vce(robust) or

 ologit SimpleCalculation MDM Age Female BMI Attendance SchoolExams NOC i.MO NumberofSchoolYears ///
 FamilyInc i.ParentsEQ[pweight=_weight], vce(robust) 
 margins, dydx(*)post
 
 drop random_order - _pdif

 *##############################################################################
              *              NUMBER RECOGNITION
 *##############################################################################
 
 ********************************** MATCHING *********************************
 
 set seed 123456
 gen random_order = uniform()
 sort random_order
 
 psmatch2 MDM Female BMI NOC SchoolExams FamilyInc, ///
 outcome(NumberRecognition) n(5) logit ate common
 
 pstest, both
 
 *********************************** OLOGIT ***********************************
 ologit NumberRecognition MDM Age Female BMI Attendance SchoolExams NOC i.MO NumberofSchoolYears ///
 FamilyInc i.ParentsEQ[pweight=_weight], vce(robust) or

 ologit NumberRecognition MDM Age Female BMI Attendance SchoolExams NOC i.MO NumberofSchoolYears ///
 FamilyInc i.ParentsEQ[pweight=_weight], vce(robust) 
 margins, dydx(*)post
 
 drop random_order - _pdif

 *<><><><><><><><><><><><><><><><><><><><><><><><><<><><><><><><><><><><><><><
 *<><><><><><><><><><>><><> DOUBLE LASSO <><><><><<>><<><><><><><><><>>>>><*
 *<><><><><><><><><><><><><><><><><><><><><><><><><<><><><><><><><><><><><><><

 *##############################################################################
              *                MATHS TEST (COMBINED SCORE)
 *##############################################################################

  **Covariate selection for MDM
  lassoShooting  MDM Age Female BMI Attendance ParentAge ParentsEQ FamilyInc ///
  Tiffin SchoolExams NOC Siblings MO NumberofSchoolYears, lasiter(1000) verbose(1) fdisplay(1)
  local treat `r(selected)'
  
  **Covariate selection for outcome
  lassoShooting  MathsTest Age Female BMI Attendance ParentAge ParentsEQ FamilyInc ///
  Tiffin SchoolExams NOC Siblings MO NumberofSchoolYears, lasiter(1000) verbose(1) fdisplay(1)
  local out_1 `r(selected)'
  
  local co_1: list treat | out_1
  
  **Ologit using union of covariates
  ologit MathsTest MDM `co_1' , vce(robust) or
  
 *#############################################################################
              *              DAILY TASK
 *##############################################################################

  **Covariate selection for MDM
  lassoShooting  MDM Age Female BMI Attendance ParentAge ParentsEQ FamilyInc ///
  Tiffin SchoolExams NOC Siblings MO NumberofSchoolYears, lasiter(1000) verbose(1) fdisplay(1)
  local treat `r(selected)'
  
  **Covariate selection for outcome
  lassoShooting DailyTask Age Female BMI Attendance ParentAge ParentsEQ FamilyInc ///
  Tiffin SchoolExams NOC Siblings MO NumberofSchoolYears, lasiter(1000) verbose(1) fdisplay(1)
  local out_2 `r(selected)'
  
  local co_2: list treat | out_2
  
  **Ologit using union of covariates
  ologit DailyTask MDM `co_2' , vce(robust) or
  
  *#############################################################################
              *              FINANCIAL CALCULATION
 *##############################################################################

  **Covariate selection for MDM
  lassoShooting  MDM Age Female BMI Attendance ParentAge ParentsEQ FamilyInc ///
  Tiffin SchoolExams NOC Siblings MO NumberofSchoolYears, lasiter(1000) verbose(1) fdisplay(1)
  local treat `r(selected)'
  
  **Covariate selection for outcome
  lassoShooting FinancialCalculation Age Female BMI Attendance ParentAge ParentsEQ FamilyInc ///
  Tiffin SchoolExams NOC Siblings MO NumberofSchoolYears, lasiter(1000) verbose(1) fdisplay(1)
  local out_3 `r(selected)'
  
  local co_3: list treat | out_3
  
  **Ologit using union of covariates
  ologit FinancialCalculation MDM `co_3' , vce(robust) or
  
  *#############################################################################
              *             SIMPLE CALCULATION
 *##############################################################################

  **Covariate selection for MDM
  lassoShooting  MDM Age Female BMI Attendance ParentAge ParentsEQ FamilyInc ///
  Tiffin SchoolExams NOC Siblings MO NumberofSchoolYears, lasiter(1000) verbose(1) fdisplay(1)
  local treat `r(selected)'
  
  **Covariate selection for outcome
  lassoShooting SimpleCalculation Age Female BMI Attendance ParentAge ParentsEQ FamilyInc ///
  Tiffin SchoolExams NOC Siblings MO NumberofSchoolYears, lasiter(1000) verbose(1) fdisplay(1)
  local out_4 `r(selected)'
  
  local co_4: list treat | out_4
  
  **Ologit using union of covariates
  ologit SimpleCalculation MDM `co_4' , vce(robust) or
  
  *#############################################################################
              *             NUMBER RECOGNITION
 *##############################################################################

  **Covariate selection for MDM
  lassoShooting  MDM Age Female BMI Attendance ParentAge ParentsEQ FamilyInc ///
  Tiffin SchoolExams NOC Siblings MO NumberofSchoolYears, lasiter(1000) verbose(1) fdisplay(1)
  local treat `r(selected)'
    
  **Covariate selection for outcome
  lassoShooting NumberRecognition Age Female BMI Attendance ParentAge ParentsEQ FamilyInc ///
  Tiffin SchoolExams NOC Siblings MO NumberofSchoolYears, lasiter(1000) verbose(1) fdisplay(1)
  local out_5 `r(selected)'
  
  local co_5: list treat | out_5
  
  **Ologit using union of covariates
  ologit NumberRecognition MDM `co_5' , vce(robust) or




  

  
  
