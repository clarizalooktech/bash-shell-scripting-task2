#!/bin/bash

#NAME:CLARIZA LOOK
#Created using: Windows 10 Home WSL 
###IMPORTANT NOTE####I have to convert the file using [dos2unix ./plotdata.sh] to make it work in WSL
#Task: Develop TWO distinct shellscripts, or TWO distinct shell functions in one shellscript, producing TWO distinct plots.
#Sample input: 1.Run "./plothistogram.sh > histogram.html" in shell command
#..................2. Check "histogram.html" for the histogram
#Sample html output: Kilobytes Received Throughout the Day



#####Set timezone to Australia Perth Time
export TZ=Australia/Perth

#####Initialize header of the html file
function header() {
cat<<THE_END
<html>
  <head>
    <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
    <script type="text/javascript">
      google.charts.load('current', {'packages':['bar']});
    google.charts.setOnLoadCallback(drawChart);

    function drawChart() {


      var data = new google.visualization.DataTable();
      data.addColumn('timeofday', 'Time of Day (Converted to UTC Timezone)');
      data.addColumn('number', 'Kilobytes Received');

      data.addRows([
THE_END
}


function footer(){
cat<<THE_END
      ]);

      var options = {
        title: 'Kilobytes Received This the Time of the Day',
        height: 450
      };

      var chart = new google.charts.Bar(document.getElementById('chart_div'));

      chart.draw(data, google.charts.Bar.convertOptions(options));
    }
    </script>
  </head>
  <body>
    <div id="chart_div" style="width: 900px; height: 500px;"></div>
  </body>
</html>
THE_END
}



function change_month_to_numb () {
	
	if [[ "$month" == "January" ]]; then               
		#echo "YES month IS January"
		M=0
		
	fi 
	
	if [[ "$month" == "February" ]]; then               
		#echo "YES month IS February"
		M=1
	
	fi 

	if [[ "$month" == "March" ]]; then               
		#echo "YES month IS March"
		M=2

	fi 
	
	if [[ "$month" == "April" ]]; then               
		#echo "YES month IS April"
		M=3
		
	fi 
	
	if [[ "$month" == "May" ]]; then               
		#echo "YES month IS May"
		M=4

	fi 
	
	if [[ "$month" == "June" ]]; then               
		#echo "YES month IS June"
		M=5

	fi 
	
	if [[ "$month" == "July" ]]; then               
		#echo "YES month IS July"
		M=6	
		
	fi 
	
	if [[ "$month" == "August" ]]; then               
		#echo "YES month IS August"
		M=7	
		
	fi 	
	
	if [[ "$month" == "September" ]]; then               
		#echo "YES month IS September"
		M=8	
		
	fi 	
	
	if [[ "$month" == "October" ]]; then               
		#echo "YES month IS October"
		M=9	
		
	fi 	
		if [[ "$month" == "November" ]]; then               
		#echo "YES month IS November"
		M=10	
		
	fi 	
	
	if [[ "$month" == "December" ]]; then               
		#echo "YES month IS December"
		M=11	
		
	fi 	
}

#####Function that converts date format to Google charts format 
function convert_date() {
	#####Converts the extracted date to a Google charts html format
	D=`echo $date| cut -d'/' -f1`
	month=`echo $date| cut -d'/' -f2`
	Y=`echo $date| cut -d'/' -f3`
	
	#####Call function that converts the month to a number
	change_month_to_numb
	
	#echo "Year is: $Y, Month is: $M"

	  
	  
	 

}

#####Function that will load a few number of data from the text file. 
function load_data() {
	#####Read 100 number of lines from the log file and store it to my_data file
	cat $1 | head -10 > my_data 
	
	input=my_data
	
	while IFS= read -r line
	do
	  #echo "$line"
	  
	  #####Extracts the IP address part of the data
	  ip_address=`echo $line | awk -F[=' '] '{print $1}'`
	  #echo "$ip_address"
	  
	  #####Extracts the date part of the data. Basically chars between first '[' and first ':' of >>>10.4.0.14 - - [03/May/2020:03:09:27<<<
	  date=`echo $line | awk -F '[='[']|[=':']' '{print $2}'`
	  
	  
	  #####Extracts the time part of the data. 
	  time=`echo $line | cut -d" " -f4 | cut -d":" -f2,3,4`
	  #echo "Time is $time"
	  
	  #####Extracts the Hour part of the data. 
	  H=`echo $line | cut -d" " -f4 | cut -d":" -f2`
	  
	  
	  #####Extracts the mins part of the data. 
	  mins=`echo $line | cut -d" " -f4 | cut -d":" -f3`

	  
	   #####Extracts the sec part of the time in the data. 
	  sec=`echo $line | cut -d" " -f4 | cut -d":" -f4`
	  
	  	  #echo "$H,  $mins, $sec"
	  
	  #####Call the function that converts date format to Google charts format
      convert_date
	  
	  #####Extracts the URL requested part of the data. 
	  url=`echo $line | cut -d'"' -f2 | cut -d" " -f2`
	  #echo "$url"
	  
	  #####Extracts the return code part of the data.
	  return_code=`echo $line | cut -d'"' -f3 | cut -d" " -f2`
	  #echo "$return_code"
	  
	  #####Extracts the number of bytes part of the data.
	  num_bytes=`echo $line | cut -d' ' -f10`
	  #echo "$num_bytes"
	  
	  
	  #####Check if num_bytes is empty, then replace value to 0
	  if [[ "$num_bytes" == *"-"* ]]; then               
		
		num_bytes=0
	  fi 	
	  

	

	  #####Combine all 
	  echo "$H,$mins,$sec,$num_bytes"

	done < "$input"
	
} 


function read_clean_data() {
	
	####This line gets the tail of the file
	file_tail=`tail -n1 newfile`
	
	for lines in `cat $1`
	do

		if [[ "$lines" == "$file_tail" ]]; then  
			hours=`echo $lines | cut -d, -f1`
			minutes=`echo $lines | cut -d, -f2`
			seconds=`echo $lines | cut -d, -f3`
			bytes=`echo $lines | cut -d, -f4`
			
			#echo "YES lines equal to tail"
			echo "[[$hours, $minutes, $seconds], $bytes ]" 
		else
			
			hours=`echo $lines | cut -d, -f1`
			minutes=`echo $lines | cut -d, -f2`
			seconds=`echo $lines | cut -d, -f3`
			bytes=`echo $lines | cut -d, -f4`
		
			echo "[[$hours, $minutes, $seconds], $bytes ]," 
			# OUT SHOULD BE [[03, 16, 24], 31130 ],
		fi 
        	
	done
} 

header
load_data access_log20200510.txt>tempfile

#####To Remove '\r' in the tempfile caused by WSL
tr -d '\r' < tempfile > newfile

read_clean_data newfile
footer

