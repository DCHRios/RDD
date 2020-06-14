*----------------------------------------------------------------------------
*Summer class - Causal Inference jun 2020
*Name: Diana Hernández
*Assignment 4 - RDD
*Analysis of "Punishment and Deterrence:Evidence from Drunk Driving -Hansen
*Date: 14 junio 2020
*----------------------------------------------------------------------------


*1. Dummy variable bac1>00.08 
gen BAC1=1 if bac1>=0.08
replace BAC1=0 if BAC1==.
tab BAC1

       BAC1 |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |     23,010       10.72       10.72
          1 |    191,548       89.28      100.00
------------+-----------------------------------
      Total |    214,558      100.00


*2. Manipulation test bac1

rddensity bac1, c(0.08) plot

Computing data-driven bandwidth selectors.

RD Manipulation Test using local polynomial density estimation.

    Cutoff c = .08 |Left of c   Right of c          Number of obs =       214558
-------------------+----------------------          Model         = unrestricted
     Number of obs |     23010      191548          BW method     =         comb
Eff. Number of obs |      8895       13730          Kernel        =   triangular
    Order est. (p) |         2           2          VCE method    =    jackknife
    Order bias (q) |         3           3
       BW est. (h) |     0.011       0.012

Running variable: bac1.
-----------------------------------------------
            Method |          T        P>|T|
-------------------+---------------------------
            Robust |       2.2032      0.0276
-----------------------------------------------

*2.1 Histogram bac1
*The histogram height on the vertical axis is based on frequency of observations,
*with BAC on the horizontal axis. The vertical black lines represent the two legal thresholds
*at 0.08 and 0.15. The bin width is 0.001, the original precision used on the breathalyzers

kdensity bac1
histogram bac1
histogram bac1, bin(50) 
graph twoway (kdensity bac1, width(0.04) epan2 clstyle(p2))

*nicer try of graph
graph twoway (kdensity bac1, width(1) epan2 clstyle(p2)) /*ab 1 default epanikov 2
  */  (kdensity bac1, width(0.2) epan2 clstyle(p1))*//
  

*3. Table 2 Checking balance of covariates*

eststo: reg white BAC1

      Source |       SS           df       MS      Number of obs   =   214,558
-------------+----------------------------------   F(1, 214556)    =     70.39
       Model |  8.39130598         1  8.39130598   Prob > F        =    0.0000
    Residual |  25578.2432   214,556  .119214765   R-squared       =    0.0003
-------------+----------------------------------   Adj R-squared   =    0.0003
       Total |  25586.6345   214,557  .119253319   Root MSE        =    .34527

------------------------------------------------------------------------------
       white |      Coef.   Std. Err.      t    P>|t|     [95% Conf. Interval]
-------------+----------------------------------------------------------------
        BAC1 |   .0202111    .002409     8.39   0.000     .0154895    .0249327
       _cons |   .8435463   .0022762   370.60   0.000      .839085    .8480075
------------------------------------------------------------------------------
(est1 stored)

eststo: reg aged BAC1

      Source |       SS           df       MS      Number of obs   =   214,558
-------------+----------------------------------   F(1, 214556)    =     49.35
       Model |  6527.96695         1  6527.96695   Prob > F        =    0.0000
    Residual |  28383331.1   214,556  132.288685   R-squared       =    0.0002
-------------+----------------------------------   Adj R-squared   =    0.0002
       Total |  28389859.1   214,557  132.318494   Root MSE        =    11.502

------------------------------------------------------------------------------
        aged |      Coef.   Std. Err.      t    P>|t|     [95% Conf. Interval]
-------------+----------------------------------------------------------------
        BAC1 |   -.563721   .0802484    -7.02   0.000    -.7210059   -.4064361
       _cons |   35.46058   .0758234   467.67   0.000     35.31197    35.60919
------------------------------------------------------------------------------
(est2 stored)

eststo: reg acc BAC1

      Source |       SS           df       MS      Number of obs   =   214,558
-------------+----------------------------------   F(1, 214556)    =    204.04
       Model |  25.6032023         1  25.6032023   Prob > F        =    0.0000
    Residual |  26922.4801   214,556  .125479969   R-squared       =    0.0010
-------------+----------------------------------   Adj R-squared   =    0.0009
       Total |  26948.0833   214,557  .125598714   Root MSE        =    .35423

------------------------------------------------------------------------------
         acc |      Coef.   Std. Err.      t    P>|t|     [95% Conf. Interval]
-------------+----------------------------------------------------------------
        BAC1 |   .0353039   .0024715    14.28   0.000     .0304598     .040148
       _cons |   .1157757   .0023352    49.58   0.000     .1111988    .1203527
------------------------------------------------------------------------------
(est3 stored)

esttab

------------------------------------------------------------
                      (1)             (2)             (3)   
                    white            aged             acc   
------------------------------------------------------------
BAC1               0.0202***       -0.564***       0.0353***
                   (8.39)         (-7.02)         (14.28)   

_cons               0.844***        35.46***        0.116***
                 (370.60)        (467.67)         (49.58)   
------------------------------------------------------------
N                  214558          214558          214558   
------------------------------------------------------------
t statistics in parentheses
* p<0.05, ** p<0.01, *** p<0.001

esttab, se

------------------------------------------------------------
                      (1)             (2)             (3)   
                    white            aged             acc   
------------------------------------------------------------
BAC1               0.0202***       -0.564***       0.0353***
                (0.00241)        (0.0802)       (0.00247)   

_cons               0.844***        35.46***        0.116***
                (0.00228)        (0.0758)       (0.00234)   
------------------------------------------------------------
N                  214558          214558          214558   
------------------------------------------------------------
Standard errors in parentheses
* p<0.05, ** p<0.01, *** p<0.001

. esttab using Table2.rtf, se
(output written to Table2.rtf)


*6. Replicate Figure 2 
*Linear
rdplot acc bac1, c(0.08) graph_options(graphregion(color(white)) ti("Panel A. Accident") xti("BAC", margin(medium)) name(grap1, replace)) p(1)
graph export "Acc1.png", as(png) replace 
rdplot male bac1, c(0.08) graph_options(graphregion(color(white)) ti("Panel B. Male") xti("BAC", margin(medium)) name(grap2, replace)) p(1) 
graph export "Male2.png", as(png) replace 
rdplot aged bac1, c(0.08) graph_options(graphregion(color(white)) ti("Panel C. Age") xti("BAC", margin(medium)) name(grap3, replace)) p(1) 
graph export "Age3.png", as(png) replace 
rdplot white bac1, c(0.08) graph_options(graphregion(color(white))ti("Panel D. White") xti("BAC", margin(medium))name(grap4, replace)) p(1) 
graph export "White4.png", as(png) replace 

*7. Replicate Table 3 
. eststo: reg recidivism BAC1, vce(robust)

Linear regression                               Number of obs     =    214,558
                                                F(1, 214556)      =       0.20
                                                Prob > F          =     0.6526
                                                R-squared         =     0.0000
                                                Root MSE          =     .32217

------------------------------------------------------------------------------
             |               Robust
  recidivism |      Coef.   Std. Err.      t    P>|t|     [95% Conf. Interval]
-------------+----------------------------------------------------------------
        BAC1 |   .0010089   .0022413     0.45   0.653     -.003384    .0054017
       _cons |   .1167319   .0021168    55.14   0.000     .1125829    .1208808
------------------------------------------------------------------------------
(est1 stored)

. eststo: reg recidivism intbac1BAC1, vce (robust)

Linear regression                               Number of obs     =    214,558
                                                F(1, 214556)      =     191.07
                                                Prob > F          =     0.0000
                                                R-squared         =     0.0010
                                                Root MSE          =     .32202

------------------------------------------------------------------------------
             |               Robust
  recidivism |      Coef.   Std. Err.      t    P>|t|     [95% Conf. Interval]
-------------+----------------------------------------------------------------
 intbac1BAC1 |   .1549533   .0112101    13.82   0.000     .1329818    .1769249
       _cons |   .0965873   .0016298    59.26   0.000     .0933928    .0997817
------------------------------------------------------------------------------
(est2 stored)

. eststo: reg recidivism inter2bac1BAC2, vce(robust)

Linear regression                               Number of obs     =    214,558
                                                F(1, 214556)      =     191.07
                                                Prob > F          =     0.0000
                                                R-squared         =     0.0010
                                                Root MSE          =     .32202

--------------------------------------------------------------------------------
               |               Robust
    recidivism |      Coef.   Std. Err.      t    P>|t|     [95% Conf. Interval]
---------------+----------------------------------------------------------------
inter2bac1BAC2 |   .1549533   .0112101    13.82   0.000     .1329818    .1769249
         _cons |   .0965873   .0016298    59.26   0.000     .0933928    .0997817
--------------------------------------------------------------------------------
(est3 stored)

. esttab, se

------------------------------------------------------------
                      (1)             (2)             (3)   
               recidivism      recidivism      recidivism   
------------------------------------------------------------
BAC1              0.00101                                   
                (0.00224)                                   

intbac1BAC1                         0.155***                
                                 (0.0112)                   

inter2bac1~2                                        0.155***
                                                 (0.0112)   

_cons               0.117***       0.0966***       0.0966***
                (0.00212)       (0.00163)       (0.00163)   
------------------------------------------------------------
N                  214558          214558          214558   
------------------------------------------------------------
Standard errors in parentheses
* p<0.05, ** p<0.01, *** p<0.001

*8. Recreate the top panel of Figure 3 according to the following rule: 
*a.	Fit linear fit using only observations with less than 0.15 bac on the bac1
*b.	Fit quadratic fit using only observations with less than 0.15 bac on the bac1

drop if bac1>=0.15
rdplot recidivism bac1, c(0.08) graph_options(graphregion(color(white)) ti("LinearF") xti("BAC", margin(medium)) name(grap6, replace)) p(1)
rdplot recidivism bac1, c(0.08) graph_options(graphregion(color(white)) ti("QuadraticF") xti("BAC", margin(medium)) name(grap7, replace)) p(2)

