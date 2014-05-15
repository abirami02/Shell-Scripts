s script will run curl on all the urls mentioned in the "input.csv" file and out put the response time, status code, response data size. Also it runs the tests 3 times, finds the average response times of 3 runs and mark the test as "PASS" or "FAIL"

baseline=1.000
FILENAME="input.csv"

if [ -f "output.html" ]
then
    rm output.html
fi

for NETID in $@
do

prodURL="http://54.236.95.81/4.0"
stageURL="http://172.16.1.20/4.0"
prodURL5="http://54.236.95.81/5.0"
stageURL5="http://172.16.1.20/5.0"

    for j in 1 2 3 4
    do
        if [ "$j" -eq  1 ]; then
                baseURL=$prodURL
        elif [ "$j" -eq 2 ]; then
                baseURL=$stageURL
        elif [ "$j" -eq 3 ]; then
                baseURL=$prodURL5
        else
                baseURL=$stageURL5
        fi

    echo "<table border=1><caption><h3><br>API Performance Test Result for NET_ID="$NETID",Base URL="$baseURL"<br></h3></caption><th>URL</th><th>Response Time(s)</th><th>Size</th><th>Response Code</th><th>Test Result</th>" >> output.html

        cat $FILENAME | while read LINE
            do

            LINE=$(echo ${LINE/<NETID>/$NETID})
            API=$LINE
            LINE=$baseURL$LINE

            sum="0.000"
                                        
                for i in 1 2 3
                do
                    out=($(curl -sL -w "%{url_effective} %{http_code} %{time_total} %{size_download}\\n" $LINE -o skeleton.json))
                    rt=${out[2]}
                    sum=$(echo $sum+$rt | bc -l)

                done

                avg=$(echo "scale=3;$sum/3" | bc -l)

        if [ "$(echo $avg '<' $baseline | bc -l)" -eq 1 ] && [ "${out[1]}" -eq "200" ]
        then
            echo "<tr style='color:Green'><td><a href='${LINE}' target='_blank'>"$API"</a></td><td>" $avg "</td><td>"${out[3]}"</td><td>"${out[1]}"</td><td>"PASS"</td>" >> output.html
        else
            echo "<tr style='color:Red'><td><a href='${LINE}' target='_blank'>"$API"</a></td><td>" $avg "</td><td>"${out[3]}"</td><td>"${out[1]}"</td><td>"FAIL"</td>" >> output.html
        fi
        done

        echo "</table>" >> output.html

    #prodURL=$stageURL

    done
done

