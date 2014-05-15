#!/bin/bash

#This script will run curl on all the urls mentioned in the "input.csv" file and out put the response time, status code, response data size. Also it runs the tests 3 times, finds the average response times of 3 runs and mark the test as "PASS" or "FAIL"

#BASE_URL="http://54.236.156.18/4.0/"
#NETID="40635"
baseline=1.000

FILENAME="input.csv"

cat $FILENAME | while read LINE
do

sum="0.000"

for i in 1 2 3
do


out=($(curl -sL -w "%{url_effective} %{http_code} %{time_total} %{size_download}\\n" $LINE -o skeleton.json))
rt=${out[2]}

sum=$(echo $sum+$rt | bc -l)
#echo $sum

done

avg=$(echo "scale=3;$sum/3" | bc -l)
#echo $avg
#echo $baseline

#if [[ ${out[2]} < $baseline ]]
#if [[ $avg < $baseline ]]
if [ "$(echo $avg '<' $baseline | bc -l)" -eq 1 ]
then
echo ${out[0]}" $avg "${out[3]}" "${out[1]}" PASS"
else
# echo "FAIL -- " ${out[1]}" -- "$avg" -- "${out[3]}" -- "${out[0]}
echo ${out[0]}" $avg "${out[3]}" "${out[1]}" FAIL"

fi

done
