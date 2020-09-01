*a);
proc reg data=mydata.snowgeese plots=none;
model wtchange = digeff adfiber; *the model statement is ALWAYS written as Y= X1 X2...;
run;
*b);


*c);
data cutoff;
fcritical=quantile('F',.99,2,39); *quantile('f', 1-alpha, numerator df, denominator df);
proc print data=cutoff; *this will output the data table we created with the critical value;
run;

*f);
*We can change the level of significance, if desired;
proc reg data=mydata.snowgeese plots=none;
model wtchange = digeff adfiber / clb alpha=0.01; 
run;

