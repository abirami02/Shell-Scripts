#!/bin/sh

# Created by Somashekar. please email for any queries somashekar@genwi.com

# **** This script will compare the application json content in two different time stamps. eg. between baseline content and present ****
# 

BASEURL="http://54.236.156.18/4.0/"

if [ "$1" == "" ]; then
echo Enter netid
read NETID
else
NETID=$1
fi

cd $NETID

out=$(curl -sL -w "%{url_effective} %{http_code} %{time_total} %{size_download}\\n" $BASEURL"/getjson/jsonObject/"$NETID -o skeleton.json)
cat skeleton.json | sed 's/,"timestamp":[0-9]*//g' > skeleton_removeTime.json
if diff -q skeleton_removeTime.json skeleton_baseremoveTime.json ;
then
echo ${out[0]}" "${out[2]}" "${out[3]}" "${out[1]}" json-matched-PASS"
else
echo ${out[0]}" "${out[2]}" "${out[3]}" "${out[1]}" json-mis-match-FAIL"
fi

out=$(curl -sL -w "%{url_effective} %{http_code} %{time_total} %{size_download}\\n" $BASEURL"/settings/getSettings/"$NETID"/smartphone" -o smartphone.json)
if diff -q smartphone_base.json smartphone.json ;
then
echo ${out[0]}" "${out[2]}" "${out[3]}" "${out[1]}" json-matched-PASS"
else
echo ${out[0]}" "${out[2]}" "${out[3]}" "${out[1]}" json-mis-match-FAIL"
fi

out=$(curl -sL -w "%{url_effective} %{http_code} %{time_total} %{size_download}\\n" $BASEURL"/settings/getSettings/"$NETID"/tablet" -o tablet.json)
if diff -q tablet_base.json tablet.json ;
then
echo ${out[0]}" "${out[2]}" "${out[3]}" "${out[1]}" json-matched-PASS"
else
echo ${out[0]}" "${out[2]}" "${out[3]}" "${out[1]}" json-mis-match-FAIL"
fi

out=$(curl -sL -w "%{url_effective} %{http_code} %{time_total} %{size_download}\\n" $BASEURL"/getjson/skeleton/"$NETID -o skeletonobj.json)
cat skeletonobj.json |sed 's/,"timestamp":[0-9]*//g' > skeletonobj_removeTime.json 
if diff -q skeletonobj_baseremovetime.json skeletonobj_removeTime.json ; 
then
echo ${out[0]}" "${out[2]}" "${out[3]}" "${out[1]}" json-matched-PASS"
else
echo ${out[0]}" "${out[2]}" "${out[3]}" "${out[1]}" json-mis-match-FAIL"
fi

out=$(curl -sL -w "%{url_effective} %{http_code} %{time_total} %{size_download}\\n" $BASEURL"/getjson/getAllActiveTmpl/"$NETID -o getAllActiveTmpl.json)
if diff -q getAllActiveTmpl_base.json getAllActiveTmpl.json ;
then
echo ${out[0]}" "${out[2]}" "${out[3]}" "${out[1]}" json-matched-PASS"
else
echo ${out[0]}" "${out[2]}" "${out[3]}" "${out[1]}" json-mis-match-FAIL"
fi

out=$(curl -sL -w "%{url_effective} %{http_code} %{time_total} %{size_download}\\n" $BASEURL"/getjson/rootSkeletonKey/"$NETID"/-1" -o rootSkeletonKey.json)
cat rootSkeletonKey.json | sed 's/,"timestamp":[0-9]*//g' > rootSkeletonKey_removeTime.json
if diff -q rootSkeletonKey_baseremoveTime.json rootSkeletonKey_removeTime.json ;
then
echo ${out[0]}" "${out[2]}" "${out[3]}" "${out[1]}" json-matched-PASS"
else
echo ${out[0]}" "${out[2]}" "${out[3]}" "${out[1]}" json-mis-match-FAIL"
fi

out=$(curl -sL -w "%{url_effective} %{http_code} %{time_total} %{size_download}\\n" $BASEURL"/getjson/getTmplNames/"$NETID"/toolbars" -o toolbar.json)
if diff -q toolbar_base.json toolbar.json ;
then
echo ${out[0]}" "${out[2]}" "${out[3]}" "${out[1]}" json-matched-PASS"
else
echo ${out[0]}" "${out[2]}" "${out[3]}" "${out[1]}" json-mis-match-FAIL"
fi

out=$(curl -sL -w "%{url_effective} %{http_code} %{time_total} %{size_download}\\n" $BASEURL"/getjson/getTmplNames/"$NETID"/categories" -o categories.json)
if diff -q categories_base.json categories.json ;
then
echo ${out[0]}" "${out[2]}" "${out[3]}" "${out[1]}" json-matched-PASS"
else
echo ${out[0]}" "${out[2]}" "${out[3]}" "${out[1]}" json-mis-match-FAIL"
fi

out=$(curl -sL -w "%{url_effective} %{http_code} %{time_total} %{size_download}\\n" $BASEURL"/getjson/getTmplNames/"$NETID"/articles" -o articles.json)
if diff -q articles_base.json articles.json ;
then
echo ${out[0]}" "${out[2]}" "${out[3]}" "${out[1]}" json-matched-PASS"
else
echo ${out[0]}" "${out[2]}" "${out[3]}" "${out[1]}" json-mis-match-FAIL"
fi

out=$(curl -sL -w "%{url_effective} %{http_code} %{time_total} %{size_download}\\n" $BASEURL"/getjson/getTmplNames/"$NETID"/article" -o article.json)
if diff -q article_base.json article.json ;
then
echo ${out[0]}" "${out[2]}" "${out[3]}" "${out[1]}" json-matched-PASS"
else
echo ${out[0]}" "${out[2]}" "${out[3]}" "${out[1]}" json-mis-match-FAIL"
fi

out=$(curl -sL -w "%{url_effective} %{http_code} %{time_total} %{size_download}\\n" $BASEURL"/getjson/getTmplNames/"$NETID"/sections" -o sections.json)
if diff -q sections_base.json sections.json ;
then
echo ${out[0]}" "${out[2]}" "${out[3]}" "${out[1]}" json-matched-PASS"
else
echo ${out[0]}" "${out[2]}" "${out[3]}" "${out[1]}" json-mis-match-FAIL"
fi

out=$(curl -sL -w "%{url_effective} %{http_code} %{time_total} %{size_download}\\n" $BASEURL"/getjson/getTmplNames/"$NETID"/search" -o search.json)
if diff -q search_base.json search.json ;
then
echo ${out[0]}" "${out[2]}" "${out[3]}" "${out[1]}" json-matched-PASS"
else
echo ${out[0]}" "${out[2]}" "${out[3]}" "${out[1]}" json-mis-match-FAIL"
fi

out=$(curl -sL -w "%{url_effective} %{http_code} %{time_total} %{size_download}\\n" $BASEURL"/getjson/getTmplNames/"$NETID"/favourites" -o favourites.json)
if diff -q favourites_base.json favourites.json ;
then
echo ${out[0]}" "${out[2]}" "${out[3]}" "${out[1]}" json-matched-PASS"
else
echo ${out[0]}" "${out[2]}" "${out[3]}" "${out[1]}" json-mis-match-FAIL"
fi

out=$(curl -sL -w "%{url_effective} %{http_code} %{time_total} %{size_download}\\n" $BASEURL"/getjson/ads/"$NETID -o add.json)
if diff -q add_base.json add.json ;
then
echo ${out[0]}" "${out[2]}" "${out[3]}" "${out[1]}" json-matched-PASS"
else
echo ${out[0]}" "${out[2]}" "${out[3]}" "${out[1]}" json-mis-match-FAIL"
fi

out=$(curl -sL -w "%{url_effective} %{http_code} %{time_total} %{size_download}\\n" $BASEURL"getjson/articles/"$NETID"/91015/" -o categoryarticles.json)
cat categoryarticles.json | sed 's/,"timestamp":[0-9]*//g' > categoryarticles_removeTime.json
if diff -q categoryarticles_baseremoveTime.json categoryarticles_removeTime.json ;
then
echo ${out[0]}" "${out[2]}" "${out[3]}" "${out[1]}" json-matched-PASS"
else
echo ${out[0]}" "${out[2]}" "${out[3]}" "${out[1]}" json-mis-match-FAIL"
fi

out=$(curl -sL -w "%{url_effective} %{http_code} %{time_total} %{size_download}\\n" $BASEURL"getjson/articles/"$NETID"/91015/0/20" -o categoryarticlesfetch.json)
cat categoryarticlesfetch.json | sed 's/,"timestamp":[0-9]*//g' > categoryarticlesfetch_removeTime.json
if diff -q categoryarticlesfetch_baseremoveTime.json categoryarticlesfetch_removeTime.json ;
then
echo ${out[0]}" "${out[2]}" "${out[3]}" "${out[1]}" json-matched-PASS"
else
echo ${out[0]}" "${out[2]}" "${out[3]}" "${out[1]}" json-mis-match-FAIL"
fi

out=$(curl -sL -w "%{url_effective} %{http_code} %{time_total} %{size_download}\\n" $BASEURL"getjson/articles/"$NETID"/91015/20/20" -o categoryarticlesfetch1.json)
cat categoryarticlesfetch1.json | sed 's/,"timestamp":[0-9]*//g' > categoryarticlesfetch1_removeTime.json
if diff -q categoryarticlesfetch1_baseremoveTime.json categoryarticlesfetch1_removeTime.json ;
then
echo ${out[0]}" "${out[2]}" "${out[3]}" "${out[1]}" json-matched-PASS"
else
echo ${out[0]}" "${out[2]}" "${out[3]}" "${out[1]}" json-mis-match-FAIL"
fi

cd ..

##loop cat skeleton_base.json | jsawk 'return this.json[0][91014]' | jsawk -n 'out(this.item_id)'
## cat skeleton.json | sed 's/,"timestamp":[0-9]*//g'
