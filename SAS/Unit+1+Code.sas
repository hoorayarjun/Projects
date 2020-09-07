*========================================================;
*========================================================;
*                Mexican Street Vendors               ;
*========================================================;
*========================================================; 
*Detailed interviews were conducted with over 1,000 street 
vendors in the city of Puebla, Mexico, in order to study 
the factors influencing vendors’ incomes. Vendors were 
defined as individuals working in the street and included 
vendors with carts and stands on wheels and excluded 
beggars, drug dealers, and prostitutes. The researchers 
collected data on gender, age, hours worked per day, 
annual earnings, and education level. We have a sample 
of 15 vendors from this list and we will examine the 
following:

Annual Earnings (response, y)
Age (explanatory, x1)
Hours Worked Per Day (Explanatory, x2)
;

*The .sas7bdat file should be in your mydata library. If you
do not have that set up, then you will need to change the table path
in all of the procedure steps.;

*To check you have the data entered correctly, you can use the 
proc print procedure below. If it does not print the data with 
15 observations, then your file is not saved to the correct place;

proc print data=mydata.streetven;
run;


*========================================================;

*QUESTION: Step 2: (Exploratory Data Analysis) 
What is the relationship between each of the 
explanatory variables and the response?;

*You can follow the prompts for the "Scatter Plot" task and 
adjust the settings to your liking. Below is one example of 
what you can produce;


proc sgplot data=MYDATA.STREETVEN;
	scatter x=Age y=Earnings;

run;

proc sgplot data=MYDATA.STREETVEN;
	scatter x=hours y=Earnings;
run;

*We can create multiple scatter plots with one step;

proc sgscatter data=mydata.streetven;
plot earnings*(age hours)/columns=1;
run;



*========================================================;

*Step 3: Fit the model and write the least squares 
prediction equation;

*You can you the linear regression task to complete this. 
 Below is one option.
The default options in the task include several plots, so I have edited the
code from the linear regression task to below;

proc reg data=mydata.streetven plots=none;
model earnings = age hours; *the model statement is ALWAYS written as Y= X1 X2...;
run;



*you can order the variables in any order. so the code
below will produce the same predicton equation;

proc reg data=mydata.streetven plots=none;
model earnings = hours age;
run;


*We can write one step with several models
and name each of the models to easily compare;

proc reg data=mydata.streetven plots=none;
Age: model earnings = age ; *NAMEOFMODEL1: model Y=x1 x2;
Hours: model earnings =  hours;*NAMEOFMODEL2: model Y=x1 x2;
Both: model earnings = age hours; *NAMEOFMODEL3: model Y=x1 x2;
run;

*========================================================;
* STEP 5: Assess the model (Global F Test);

* To then test the overall significance we want to look at the F test.
We can look at the pvalue in the ANOVA table or compare the F statistic
to an F critical value. To use SAS to calculate the quantile
associated with the F distribution at a significance level 
use the quantile function below. See the QUANTILE help page for the inputs
and other options;

data cutoff;
fcritical=quantile('F',.95,2,12); *quantile('f', 1-alpha, numerator df, denominator df);
proc print data=cutoff; *this will output the data table we created with the critical value;
run;



*========================================================;

* STEP 5: Assess the model (Confidence intervals for Beta);

*TO add options to our proc reg step we can add a "/" in the model statement
followed by the desired options. We will learn several options throughout the semester.
To find the confidence intervals for the beta parameters,
we add the "/clb" option to the model statement. NOTE 
the default significance level in SAS is 0.05, so we must change
that as well.;

proc reg data=mydata.streetven plots=none;
model earnings = age hours / clb; 
run;

*We can change the level of significance, if desired;
proc reg data=mydata.streetven plots=none;
model earnings = age hours / clb alpha=0.01; 
run;

*If we wanted to find calcualte the interval by hand OR find the 
t-critical value at a significance level of 0.05, 
for this problem, we could use the following;

data cutoff;
tcritical=quantile('T',.975,12);*quantile('t', 1-(alpha/2), df;
proc print data=cutoff;
run;

*========================================================;
*========================================================;
*Step 7: Prediction and Estimation;

*QUESTION: What is the predicted yearly earnings for a vendor
that is 45 years old and works 10 hours per day?;


*"plug in directly method";
*SAS does not function like a calculator, so we must create a 
data set with one observation. Below is an example of how you 
can use SAS to perform calculations;

data est;
yhat1 = -20.35201 + 13.35045*45 + 243.71446*10; 
*creates a new variable called yhat1 that is defined by the equation;
proc print data=est; *prints the new variables;
run;


*The more efficient way to add a new observation to a data set,
whether you want to use it for prediction or if you just collected 
new data, is to make a data table with the new observations then
use the "set" statement to merge the tables together.;

*Make a data table with the new observations. There are a few ways to do this, 
we will use this for now. We want to use our prediction equation to
predict from a new set of x values, you will put the response variable as missing 
with a . ;
 
data streetvenpre;
input age hours;
cards;
45 10
;
run;

*SAS will automatically make the missing columns as missing values;

*You can view the data table with the new observations;
proc print data=streetvenpre;
run;

*Then create a new data table that merges the original data and the new
observations;
*by adding the "mydata" library, this will automatically store this new data 
table to your library.;
*SAS will automatically make the missing columns for earnings 
as missing value;

data mydata.streetven1; *the name of the new data table;
set mydata.streetven streetvenpre; *the original data table and the rows we are adding;
run;

*View the new data table with the added observations;

proc print data=mydata.streetven1;
run;

*NOW TO USE THIS FOR PREDICTION/ESTIMATION;

*Add the "/p" option to the model statement and the
 the last lines will be the prediction for the new observations;

proc reg data=mydata.streetven1 plots=none; *note we have the name of the new data table;
model earnings = age hours / p;
run;

*========================================================;

*QUESTION: What is the 95% interval estimate for the 
yearly earnings for a vendor that is 45 years old and 
works 10 hours per day?;

*We have already created a new table with this observation,
in order to use SAS to find a prediction interval for y, 
we add the option "/cli" to the end of the model statement;


proc reg data=mydata.streetven1 plots=none; 
model earnings = age hours / cli;
run;

*We can also put both options in the model statement;

proc reg data=mydata.streetven1 plots=none; 
model earnings = age hours / clm cli;
run;

*========================================================;

* QUESTION: What is the 95% interval estimate for the average 
yearly earnings for vendors that is 45 years old and 
works 10 hours per day?;

*We have already created a new table with this observation,
in order to use SAS to find a confidence interval for the mean 
value of y, we add the option "/clm" to the end of the model statement;


proc reg data=mydata.streetven1 plots=none; *note we have the name of the new data table;
model earnings = age hours / clm;
run;

*Just like the confidence interval for Beta parameters, 
we can change the significane level;

*I.E. If we want a 99% confidence interval;

proc reg data=mydata.streetven1 plots=none; *note we have the name of the new data table;
model earnings = age hours / clm alpha=0.01;
run;



