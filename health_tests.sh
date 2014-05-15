#!/bin/bash

BUILD_NUMBER=$1

echo "******** SERVER  HEALTH CHECK JOB RESULTS **********"
ant -file /Users/abirami/Documents/QA/QA/mCMS_Automation_Scripts/serverHealthTest/build.xml run >> output.txt
cp /Users/abirami/Documents/QA/QA/mCMS_Automation_Scripts/serverHealthTest/test-output/emailable-report.html /Users/apache/Documents/private/test-output/Health-Check-Test/$BUILD_NUMBER-emailable-report.html
echo "Local Network - http://gwindia.local/private/test-output/Health-Check-Test/$BUILD_NUMBER-emailable-report.html"
echo "Public Network - http://182.73.7.129/private/test-output/Health-Check-Test/$BUILD_NUMBER-emailable-report.html"

echo "******** SERVER  HEALTH CHECK JOB RESULTS **********" >> mail_$BUILD_NUMBER.txt
echo "Local Network - http://gwindia.local/hudson/job/Health%20Check%20Test/$BUILD_NUMBER/console">> mail_$BUILD_NUMBER.txt
echo "Public Network - http://182.73.7.129/hudson/job/Health%20Check%20Test/$BUILD_NUMBER/console" >> mail_$BUILD_NUMBER.txt

echo "******** HEALTH CHECK TESTS FOR PHP SERVER STARTED *******"
echo "Test URL http://app.genwi.com/4.0/getjson/jsonObject/40635 "
out1=($(curl -sL -w "%{url_effective} %{http_code} %{time_total} %{size_download}\\n" http://app.genwi.com/4.0/getjson/jsonObject/40635 -o skeleton.json))
echo "Response: Status Code" ${out1[1]}
echo "Response: Data Download Size" ${out1[3]}

echo "Test URL http://app.genwi.com/4.0/getjson/jsonObject/41671 "
out2=($(curl -sL -w "%{url_effective} %{http_code} %{time_total} %{size_download}\\n" http://app.genwi.com/4.0/getjson/jsonObject/41671 -o skeleton.json))
echo "Response: Status Code" ${out2[1]}
echo "Response: Data Download Size" ${out2[3]}

if [ "${out1[3]}" -lt "200" ] || [ "${out1[1]}" -ne "200" ] || [ "${out2[3]}" -lt "200" ] || [ "${out2[1]}" -ne "200" ]
then 
echo "FAILURE"
echo "************* SENDING MAIL FOR PHP SERVER FAILURE ************* "
echo "The PHP Server seems to be down. Please check http://app.genwi.com/4.0/getjson/jsonObject/40635" >> mail_$BUILD_NUMBER.txt

(
echo "From: abirami@genwi.com"
echo "To: abirami@genwi.com shivank@genwi.com ved@genwi.com"
echo "MIME-Version: 1.0"
echo "Subject: Server Health Check Status - FAILURE" 
echo "Content-Type: text/html" 
cat mail_$BUILD_NUMBER.txt
) | sendmail -t

else
echo "SUCCESS"
fi
echo "******** HEALTH CHECK TESTS FOR PHP SERVER COMPLETED  *******"

echo "******** HEALTH CHECK TESTS FOR GENWI.COM SERVER STARTED *******"
echo "Test URL http://genwi.com "
out3=($(curl -sL -w "%{url_effective} %{http_code} %{time_total} %{size_download}\\n" http://genwi.com -o skeleton.json))
echo "Response: Status Code" ${out3[1]}
echo "Response: Data Download Size" ${out3[3]}

echo "Test URL http://showcase.genwi.com/showcase.aspx "
out4=($(curl -sL -w "%{url_effective} %{http_code} %{time_total} %{size_download}\\n" http://showcase.genwi.com/showcase.aspx -o skeleton.json))
echo "Response: Status Code" ${out4[1]}
echo "Response: Data Download Size" ${out4[3]}

if [ "${out3[3]}" -lt "500" ] || [ "${out3[1]}" -ne "200" ] || [ "${out4[3]}" -lt "500" ] || [ "${out4[1]}" -ne "200" ]
then
echo "FAILURE"
echo "************* SENDING MAIL FOR GENWI.COM SERVER FAILURE ************* "
echo "The Genwi.com seems to be down. Please check http://genwi.com/" >> mail_$BUILD_NUMBER.txt

(
echo "From: abirami@genwi.com"
echo "To: abirami@genwi.com shivank@genwi.com ved@genwi.com"
echo "MIME-Version: 1.0"
echo "Subject: Server Health Check Status - Failure"
echo "Content-Type: text/html"
cat mail_$BUILD_NUMBER.txt
) | sendmail -t
else
echo "SUCCESS"
fi
echo "******** HEALTH CHECK TESTS FOR GENWI.COM SERVER COMPLETED *******"

echo "******** HEALTH CHECK TESTS FOR mCMS SERVER STARTED *******"
echo "Test URL http://mcms.genwi.com "
out5=($(curl -sL -w "%{url_effective} %{http_code} %{time_total} %{size_download}\\n" http://mcms.genwi.com -o skeleton.json))
echo "Response: Status Code " ${out5[1]}
echo "Response: Data download Size" ${out5[3]}

if [ "${out5[3]}" -lt "300" ] || [ "${out5[1]}" -ne "200" ]
then
echo "FAILURE"
echo "************* SENDING MAIL FOR mCMS SERVER FAILURE ************* "
echo "The mCMS seems to be down. Please check http://mcms.genwi.com/" >> mail_$BUILD_NUMBER.txt

(
echo "From: abirami@genwi.com"
echo "To: abirami@genwi.com ved@genwi.com shivank@genwi.com"
echo "MIME-Version: 1.0"
echo "Subject: Server Health Check Status - Failure"
echo "Content-Type: text/html"
cat mail_$BUILD_NUMBER.txt
) | sendmail -t
else
echo "SUCCESS"
fi
echo "******** HEALTH CHECK TESTS FOR mCMS SERVER COMPLETED *******"
echo "************* SENDING MAIL FOR SUCCESS ************* "

(
echo "From: abirami@genwi.com"
echo "To: abirami@genwi.com shivank@genwi.com ved@genwi.com"
echo "MIME-Version: 1.0"
echo "Subject: Server Health Check Status - SUCCESS"
echo "Content-Type: text/html"
cat mail_$BUILD_NUMBER.txt
) | sendmail -t

