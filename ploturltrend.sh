#!/bin/bash

#NAME:CLARIZA LOOK
#ID: 22860721
#Created using: Windows 10 Home WSL 
###IMPORTANT NOTE####I have to convert the file using [dos2unix ./plotdata.sh] to make it work in WSL
#Task: Develop TWO distinct shellscripts, or TWO distinct shell functions in one shellscript, producing TWO distinct plots.
#Sample input line: Run "./ploturltrend.sh > urltrend.html" in shell command (give about 1min to process)
#Sample data output: Check "urltrend.html" for the URL TREND 




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
        var data = google.visualization.arrayToDataTable([
		          ['URL', 'Number of Hits'],
THE_END
}


function footer(){
cat<<THE_END
         ]);

        var options = {
          chart: {
            title: 'Top Trending URLS',
            subtitle: 'Based from 60 datasets',
          },
          bars: 'horizontal' // Required for Material Bar Charts.
        };

        var chart = new google.charts.Bar(document.getElementById('barchart_material'));

        chart.draw(data, google.charts.Bar.convertOptions(options));
      }
    </script>
  </head>
  <body>
    <div id="barchart_material" style="width: 900px; height: 500px;"></div>
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
	cat $1 | head -60 > my_data 
	
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
	  
	  exact_url=`echo $url | awk -F[='?'] '{print $1}'`
	  
	 
	  
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
	  
	  echo "$exact_url"

	done < "$input"
	
} 
function construct_html_data (){
	####This line gets the tail of the file
	get_tail=`tail -n1 $1`
	
	input1=$1
	
	while IFS= read -r line1
	do
		if [[ "$line1" == "$get_tail" ]]; then  
			url_name=`echo $line1 | cut -d" " -f2`
			hits=`echo $line1 | cut -d" " -f1`

			echo "['$url_name', $hits] "
			###should be  ['url_name', 3]
		else
			
			url_name=`echo $line1 | cut -d" " -f2`
			hits=`echo $line1 | cut -d" " -f1`
			echo "['$url_name', $hits], "
			
		fi 
	done < "$input1"

}

header
load_data access_log20200510.txt>tempurlfile

#####To Remove '\r' in the tempfile caused by WSL
tr -d '\r' < tempurlfile > newurlfile

sort -n newurlfile| uniq -c >sorted_uniq_urls

#####To Remove '\r' in the sorted_uniq_urls caused by WSL
tr -d '\r' < sorted_uniq_urls > newsorted_uniq_urls


construct_html_data newsorted_uniq_urls


footer

