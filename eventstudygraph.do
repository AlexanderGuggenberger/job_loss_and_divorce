gen D1=(F3.treat==1)
gen D2=(F2.treat==1)
gen D3=(F.treat==1)
gen D4=(treat==1)
gen D5=(L.treat==1)
gen D6=(L2.treat==1)
gen D7=(L3.treat==1)

xtlogit divorce D1 D2 D3 D4 D5 D6 D7 year kids, fe vce(oim)

sca baseline=(_b[D1]+_b[D2]+_b[D3]+_b[D4]+_b[D5]+_b[D6]+_b[D7])/7

sca normD1=_b[D1]-baseline
sca normD2=_b[D2]-baseline
sca normD3=_b[D3]-baseline
sca normD4=_b[D4]-baseline
sca normD5=_b[D5]-baseline
sca normD6=_b[D6]-baseline
sca normD7=_b[D7]-baseline

sca lowci1=normD1-1.96*_se[D1]
sca lowci2=normD2-1.96*_se[D2]
sca lowci3=normD3-1.96*_se[D3]
sca lowci4=normD4-1.96*_se[D4]
sca lowci5=normD5-1.96*_se[D5]
sca lowci6=normD6-1.96*_se[D6]
sca lowci7=normD7-1.96*_se[D7]

sca highci1=normD1+1.96*_se[D1]
sca highci2=normD2+1.96*_se[D2]
sca highci3=normD3+1.96*_se[D3]
sca highci4=normD4+1.96*_se[D4]
sca highci5=normD5+1.96*_se[D5]
sca highci6=normD6+1.96*_se[D6]
sca highci7=normD7+1.96*_se[D7]

gen mean=.
gen lowci=.
gen highci=.

local i=1
quietly while `i'<=7 {

replace mean=normD`i' in `i'
replace lowci=lowci`i' in `i'
replace highci=highci`i' in `i'
local i=`i'+1

}

gen t=_n
lab def time 1 "-3" 2 "-2" 3 "-1" 4 "0" 5 "1" 6 "2" 7 "3", replace
lab values t time

*do not forget that, depending on the specification above, one time unit is on or two years respectively

twoway (sc mean t, mcolor(navy) lcolor(navy) connect(direct))(rcap lowci highci t, lcolor(navy) name("$title") title("$title") xlab(,val)) if t<=7

drop D1 D2 D3 D4 D5 D6 D7 mean lowci highci t
