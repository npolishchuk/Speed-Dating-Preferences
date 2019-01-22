*--Compute Spearman correlations for self-assessment vs. partner ratings;
proc corr data = females nosimple spearman;
var AvgAttr	AvgSinc	AvgIntel	AvgFun	AvgAmb;
with SelfAttr	SelfSinc	SelfFun	SelfIntel	SelfAmb;
run;
title 'Preference Ratings for Women by Male Speed Date Partners in Wave 8';

ods graphics on;

 *PCA of original data;
 proc princomp data = MalePrefWv8;
 	ods select EigenvaluePlot;
	var M184-M193;
	run;

*--Compute coordinates for a 2-dimensional scatter plot of participants in a single sex and wave --;
	proc prinqual data = MalePrefWv8 out = Results n=2 replace mdpref;
title2 'Second nonmetric MDPREF Analysis';
title3 'Optimal Monotonic Transformation of Preference Data';
id FID AvgAttr AvgSinc	AvgIntel AvgFun	AvgAmb	AvgShar;
transform monotone (M184-M193);
run;

*Final PCA;
proc princomp data =Results;
ods select EigenvaluePlot;
var M184-M193;
where _TYPE_ = 'SCORE';
run;

*--Compute endpoints for Attribute Vectors ---;
proc transreg data = PResults;
  Model identity(AvgAttr AvgSinc AvgIntel AvgFun	AvgAmb	AvgShar) = identity(Prin1 Prin2);
  output tsdandard= center coordinates replace out=TResult1;
  id femaleID;
  title2 'Preference Mapping (PREFMAP) Analysis';
run;

data plot;
 title3 'Plot of women and their ratings';
 set Tresult1;
 run;

 %plotit(data = plot, datatype=vector ideal, antiidea=1, HREF = 0, vref = 0);


ods graphics off;
