#!/bin/sh

./api_perf.sh > output.csv

awk 'BEGIN{print "<table border=1>"} {print "<tr>";for(i=1;i<=NF;i++)print "<td>" $i"</td>";print "</tr>"} END{print "</table>"}' output.csv > output-$(date +%m-%d-%y).html

#cat "output.html" | mail -s "Server API Test Results" abirami@genwi.com

(
echo "From: abirami@genwi.com"
echo "To: abirami@genwi.com somashekar@genwi.com"
echo "MIME-Version: 1.0"
echo "Subject: Server API Test Results" 
echo "Content-Type: text/html" 
cat output.html
) | sendmail -t
