libname mydata "/folders/myfolders";

/** Import an XLSX file.  **/
PROC IMPORT DATAFILE="/folders/myfolders/02KEL444-AirFrance_student.xls"
		    OUT=mydata.MYEXCEL
		    DBMS=XLS;
		    SHEET="DoubleClick";
		    REPLACE;
RUN;

/** Data Steps **/
data mydata.MYEXCEL1(rename=(Engine_Click_Thru__=CTR Avg__Pos_=Avg_Pos));
	set mydata.myexcel;
	net_revenue = amount - total_cost;
	if total_cost ne 0 then ROI = net_revenue/total_cost;
	if Total_Volume_of_Bookings ne 0
		then revenue_booking = net_revenue/Total_Volume_of_Bookings;

/** Creating Dummy Variable **/
data mydata.MYEXCEL2;
	set mydata.myexcel1;
	if find(keyword, 'air france','airfrance') ge 1
		then brand = 1;
	else brand = 0;
run;

/**  Statistics of the Data **/
proc means data=mydata.MYEXCEL2 N mean std min max stderr skewness kurtosis maxdec=1;

/** Correlation **/
proc corr data=mydata.MYEXCEL1 nosimple; var Search_Engine_Bid avg_pos CTR net_revenue ROI;

/** Regression **/
proc reg data=mydata.MYEXCEL2;	model CTR = Search_Engine_Bid avg_pos brand; run;

/** Plot **/
proc plot data=mydata.MYEXCEL2;
	plot CTR * avg_pos = '*';
run;

/** Sort **/
proc sort data=mydata.MYEXCEL2; BY publisher_name; run;
