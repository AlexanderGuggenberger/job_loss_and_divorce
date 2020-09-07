* main code

clear
graph drop _all

cd "D:\Advanced Micro\Projekt2.try\project"

use project

* DATA PREPARATION -----------------------------------------------------------------------------------------

* labelling of string variable values

do labels

* renaming (and dropping supergfluous variables I accidently included)

do names

* homogenise different years

* marital status: category "remarried" abolished in 1992, change remarried observations to married

replace married1979=1 if married1992==5
replace married1980=1 if married1992==5
replace married1981=1 if married1992==5
replace married1982=1 if married1992==5
replace married1983=1 if married1992==5
replace married1984=1 if married1992==5
replace married1985=1 if married1992==5
replace married1986=1 if married1992==5
replace married1987=1 if married1992==5
replace married1988=1 if married1992==5
replace married1989=1 if married1992==5
replace married1990=1 if married1992==5
replace married1991=1 if married1992==5
replace married1992=1 if married1992==5


* reason respondent left the job: different categories. I put "layoff" and "plant closed" into 1, "fired" or "discharged" into 2

do whyleft


* transform data to long format

reshape long whyleft whylefttwo whyleftthree whyleftfour whyleftfive inc incs age married kids joblinedupone joblineduptwo joblinedupthree joblinedupfour joblinedupfive weeksue numjobs, i(id) j(year)


* finish homogenization of whyleft
* note that I have data on up to five jobs per year

replace whyleft=3 if whyleft!=1 & whyleft!=2 & whyleft!=-4 & whyleft!=-5
replace whylefttwo=3 if whylefttwo!=1 & whylefttwo!=2 & whylefttwo!=-4 & whylefttwo!=-5
replace whyleftthree=3 if whyleftthree!=1 & whyleftthree!=2 & whyleftthree!=-4 & whyleftthree!=-5
replace whyleftfour=3 if whyleftfour!=1 & whyleftfour!=2 & whyleftfour!=-4 & whyleftfour!=-5
replace whyleftfive=3 if whyleftfive!=1 & whyleftfive!=2 & whyleftfive!=-4 & whyleftfive!=-5


* labelling variables

label variable kids "# of kids in household"
label variable inc "own income before taxes"
label variable incs "spouse's income before taxes"


*replace -5 (no data because not interviewed this year) by "."

replace whyleft=. if whyleft==-5
replace whylefttwo=. if whylefttwo==-5
replace whyleftthree=. if whyleftthree==-5
replace whyleftfour=. if whyleftfour==-5
replace whyleftfive=. if whyleftfive==-5

replace joblinedupone=. if joblinedupone==-5
replace joblineduptwo=. if joblineduptwo==-5
replace joblinedupthree=. if joblinedupthree==-5
replace joblinedupfour=. if joblinedupfour==-5
replace joblinedupfive=. if joblinedupfive==-5

replace weeksue=. if weeksue==-5|weeksue==-4
replace kids=. if kids==-5|kids==-4
replace inc=. if inc==-5
replace incs=. if incs==-5
replace married=. if married==-5|married==-4|married==-3|married==-2|married==-1
replace age=. if age==-5
replace numjobs=. if numjobs==-4

* declare data as panel data

xtset id year


* generating the dummy "divorce" that indicates a divorce or separation

gen aux=1 if married==1
replace aux=0 if married==2|married==3
gen aux2=d.aux

gen divorce=1 if d.aux==-1
replace divorce=0 if divorce!=1

drop aux aux2


* generating dummies for reasons left and whether a job is lined up

*fired

gen firedone=1 if whyleft==2
replace firedone=0 if firedone!=1

gen firedtwo=1 if whylefttwo==2
replace firedtwo=0 if firedtwo!=1

gen firedthree=1 if whyleftthree==2
replace firedthree=0 if firedthree!=1

gen firedfour=1 if whyleftfour==2
replace firedfour=0 if firedfour!=1

gen firedfive=1 if whyleftfive==2
replace firedfive=0 if firedfive!=1

gen fired=1 if firedone==1|firedtwo==1|firedthree==1|firedfour==1|firedfive==1
replace fired=0 if fired!=1


* layoff

gen layoffone=1 if whyleft==1
replace layoffone=0 if layoffone!=1

gen layofftwo=1 if whylefttwo==1
replace layofftwo=0 if layofftwo!=1

gen layoffthree=1 if whyleftthree==1
replace layoffthree=0 if layoffthree!=1

gen layofffour=1 if whyleftfour==1
replace layofffour=0 if layofffour!=1

gen layofffive=1 if whyleftfive==1
replace layofffive=0 if layofffive!=1

gen layoff=1 if layoffone==1|layofftwo==1|layoffthree==1|layofffour==1|layofffive==1
replace layoff=0 if layoff!=1


* layoff or fired

gen layofforfiredone=1 if whyleft==1|whyleft==2
replace layofforfiredone=0 if layofforfiredone!=1

gen layofforfiredtwo=1 if whylefttwo==1|whylefttwo==2
replace layofforfiredtwo=0 if layofforfiredtwo!=1

gen layofforfiredthree=1 if whyleftthree==1|whyleftthree==2
replace layofforfiredthree=0 if layofforfiredthree!=1

gen layofforfiredfour=1 if whyleftfour==1|whyleftfour==2
replace layofforfiredfour=0 if layofforfiredfour!=1

gen layofforfiredfive=1 if whyleftfive==1|whyleftfive==2
replace layofforfiredfive=0 if layofforfiredfive!=1

gen layofforfired=1 if layofforfiredone==1|layofforfiredtwo==1|layofforfiredthree==1|layofforfiredfour==1|layofforfiredfive==1
replace layofforfired=0 if layofforfired!=1


* any reason

gen anyreasonone=1 if whyleft==1|whyleft==2|whyleft==3
replace anyreasonone=0 if anyreasonone!=1

gen anyreasontwo=1 if whylefttwo==1|whylefttwo==2|whylefttwo==3
replace anyreasontwo=0 if anyreasontwo!=1

gen anyreasonthree=1 if whyleftthree==1|whyleftthree==2|whyleftthree==3
replace anyreasonthree=0 if anyreasonthree!=1

gen anyreasonfour=1 if whyleftfour==1|whyleftfour==2|whyleftfour==3
replace anyreasonfour=0 if anyreasonfour!=1

gen anyreasonfive=1 if whyleftfive==1|whyleftfive==2|whyleftfive==3
replace anyreasonfive=0 if anyreasonfive!=1

gen anyreason=1 if anyreasonone==1|anyreasontwo==1|anyreasonthree==1|anyreasonfour==1|anyreasonfive==1
replace anyreason=0 if anyreason!=1


* job lined up for any of the jobs lost

gen joblinedup=1 if joblinedupone==1|joblineduptwo==1|joblinedupthree==1|joblinedupfour==1|joblinedupfive==1
replace joblinedup=0 if joblinedup!=1


* generate a variable for the income difference between the spouses

replace inc =. if inc==-4
replace incs=. if incs==-4


* instrumenting income

reg l.inc l2.inc race sex kids age year
predict ivinc

* generating a variable for income difference

gen ivdinc=incs-ivinc
gen dinc=incs-inc

* change sex dummy from 1,2 to 1,0

replace sex=0 if sex==2


* two ways of dealing with having one year intervals until 1994, two year intervals from 1994 on

* 1) deleting the extra interviews in the first half

*drop if mod(year, 2)!=0

* 2) using only the first half

drop if year>1994


* DATA ANALYSIS ---------------------------------------------------------------------------------------------

* I) summary statistics and graphs

sum divorce year kids numjobs inc dinc

hist dinc if sex==1, percent name(males)
hist dinc if sex==0, percent name(females)


* II) OLS: naive and with controls


gen treat1=(layofforfired==1&joblinedup==0&weeksue>0)

* by the condition weeksue>0 I make sure that the job they were fired from was their last/only job

reg divorce treat, vce(cluster id)
reg divorce treat race sex kids dinc age numjobs year, vce(cluster id)
logit divorce treat race sex kids dinc age numjobs year, vce(cluster id)


* III) Fixed effects logit model: regressing the probability of a divorce or separation on different treatment dummies


gen treat2=(weeksue>0)
gen treat3=(fired==1&joblinedup==0&weeksue>0)
gen treat4=(anyreason==1&joblinedup==0&weeksue>0) 
gen treat5=(layoff==1&joblinedup==0&weeksue>0)

* compare different treatment definitions

quiet xtlogit divorce treat1 year kids, fe vce(oim)
eststo reg2
quiet xtlogit divorce treat2 year kids, fe vce(oim)
eststo seg2
quiet xtlogit divorce treat3 year kids, fe vce(oim)
eststo teg2
quiet xtlogit divorce treat4 year kids, fe vce(oim)
eststo ueg2
quiet xtlogit divorce treat5 year kids, fe vce(oim)
eststo veg2

esttab reg2 seg2 teg2 ueg2 veg2, se compress mtitles("layoff or fired" "unemployed" "fired" "anyreason" "layoff")
esttab reg2 seg2 teg2 ueg2 veg2 using treatments.tex, se compress mtitles("layoff or fired" "unemployed" "fired" "anyreason" "layoff")

* try to instrument income

quiet xtlogit divorce treat3 year, fe vce(oim)
eststo teg1
quiet xtlogit divorce treat3 year kids, fe vce(oim)
eststo teg2
quiet xtlogit divorce treat3 year kids inc, fe vce(oim)
eststo teg3
quiet xtlogit divorce treat3 year kids inc dinc, fe vce(oim)
eststo teg4
quiet xtlogit divorce treat3 year kids l.inc l.dinc, fe vce(oim)
eststo teg5
quiet xtlogit divorce treat3 year kids numjobs ivinc ivdinc, fe vce(oim)
eststo teg6

esttab teg*, se compress
esttab teg* using ivinc.tex, se compress

* efect by subgroup

quiet xtlogit divorce treat3 year kids if sex==1, fe vce(oim)
eststo sub1
quiet xtlogit divorce treat3 year kids if sex==0, fe vce(oim)
eststo sub2
quiet xtlogit divorce treat3 year kids if l.dinc<=0, fe vce(oim)
eststo sub3
quiet xtlogit divorce treat3 year kids if l.dinc>0, fe vce(oim)
eststo sub4

esttab sub*, se compress mtitles("males" "females" "higher inc than partner" "lower inc than partner")
esttab sub* using subgroups.tex, se compress mtitles("males" "females" "higher inc than partner" "lower inc than partner")

* find marginal effect

quiet xtlogit divorce i.treat3 i.year i.kids, fe vce(oim)
margins, dydx(treat3)

sum divorce if treat3!=1

* event study analysis

gen treat=.


*for treat1

replace treat=treat1
global title="treat1"
do eventstudygraph.do
graph export treat1.pdf

*for treat2

replace treat=treat2
global title="treat2"
do eventstudygraph.do
graph export treat2.pdf

*for treat3

replace treat=treat3
global title="treat3"
do eventstudygraph.do
graph export treat3.pdf

* for treat4

replace treat=treat4
global title="treat4"
do eventstudygraph.do
graph export treat4.pdf


* paper zu event study analysis
https://watermark.silverchair.com/119-4-1383.pdf?token=AQECAHi208BE49Ooan9kkhW_Ercy7Dm3ZL_9Cf3qfKAc485ysgAAAl4wggJaBgkqhkiG9w0BBwagggJLMIICRwIBADCCAkAGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMYKf9IhOdhKgzejJ8AgEQgIICEdWAvRcnRFvEOMyzH1LhkqyD0a7l96seGm1CUn8madqW16LJBDvPAJiSwryJi7epfGodlpHIK9pfLRHKgm8nE1FDzLhIZTVlV5A4dpBqY2EJbD6wzRu4qxLHLWMcoLeXK9v04xB5pMj1FYizVdZh14aiyB_ZGXa1wjAzhciXg5vBIsLGaoJgbdAXoIDbLuX8vYClyXc6AS7Wfo2nd2t2yNbxsLSFMjbG--zb2PsP9zEsgTaUBrAHgpCH4faLMkt_VzLroHwa-zzDSsyK64iOZrdclEh3NPnl0EHZ6Fj4Yh0j7gpNDXpwaUnE-Tf4voDq-VyU0OPncbopdXi8opoUMGuHZ1WdG3Wm31h3DxO3xTY87o7mK8dbkA_SDEmxTihEpHuxOsHRtiqPOC7rwEhWwopJ1HmwQumTGZkjRHteLZfmJYpmAOt-khIbp1tpUIA0y5Sz9KZk3ZKzdFlPWpqZx5lvVHmmXkSZVvCL2Auwc4ZlJLniV8BYeJQRPQz-3Qx62OXCfrtRWYAyx0gC7xrkb77JEjJsUfwiTLmkLYZlfU7rkL1HuQIFYrKkU2p-_SHguRIqeKzFamT6Vph8oBHjm9XtGiJ5orm1ZRbXMd_wmf6Hp57t5ABnOlBGaugkh9Ef28rKqwXZTvir7AR4ZRqL65JbQXQyto0Y1Id_soT8N-8l-1HdGT40RUCb9MCPe9ob-ps





