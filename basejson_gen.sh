#!/bin/sh

BASEURL="http://54.236.156.18/4.0/"

if [ "$1" == "" ]; then
echo Enter netid
read NETID
else
NETID=$1
fi

mkdir $NETID
cd $NETID

curl -sL -w "%{url_effective} %{http_code} %{time_total} %{size_download}\\n" $BASEURL"/getjson/jsonObject/"$NETID -o skeleton_base.json
cat skeleton_base.json | sed 's/,"timestamp":[0-9]*//g' > skeleton_baseremoveTime.json

curl -sL -w "%{url_effective} %{http_code} %{time_total} %{size_download}\\n" $BASEURL"/settings/getSettings/"$NETID"/smartphone" -o smartphone_base.json
curl -sL -w "%{url_effective} %{http_code} %{time_total} %{size_download}\\n" $BASEURL"/settings/getSettings/"$NETID"/tablet" -o tablet_base.json

curl -sL -w "%{url_effective} %{http_code} %{time_total} %{size_download}\\n" $BASEURL"/getjson/skeleton/"$NETID -o skeletonobj_base.json
cat skeletonobj_base.json |sed 's/,"timestamp":[0-9]*//g' > skeletonobj_baseremoveTime.json 

curl -sL -w "%{url_effective} %{http_code} %{time_total} %{size_download}\\n" $BASEURL"/getjson/getAllActiveTmpl/"$NETID -o getAllActiveTmpl_base.json

curl -sL -w "%{url_effective} %{http_code} %{time_total} %{size_download}\\n" $BASEURL"/getjson/rootSkeletonKey/"$NETID"/-1" -o rootSkeletonKey_base.json
cat rootSkeletonKey_base.json | sed 's/,"timestamp":[0-9]*//g' > rootSkeletonKey_baseremoveTime.json

curl -sL -w "%{url_effective} %{http_code} %{time_total} %{size_download}\\n" $BASEURL"/getjson/getTmplNames/"$NETID"/toolbars" -o toolbar_base.json
curl -sL -w "%{url_effective} %{http_code} %{time_total} %{size_download}\\n" $BASEURL"/getjson/getTmplNames/"$NETID"/categories" -o categories_base.json
curl -sL -w "%{url_effective} %{http_code} %{time_total} %{size_download}\\n" $BASEURL"/getjson/getTmplNames/"$NETID"/articles" -o articles_base.json
curl -sL -w "%{url_effective} %{http_code} %{time_total} %{size_download}\\n" $BASEURL"/getjson/getTmplNames/"$NETID"/article" -o article_base.json
curl -sL -w "%{url_effective} %{http_code} %{time_total} %{size_download}\\n" $BASEURL"/getjson/getTmplNames/"$NETID"/sections" -o sections_base.json
curl -sL -w "%{url_effective} %{http_code} %{time_total} %{size_download}\\n" $BASEURL"/getjson/getTmplNames/"$NETID"/search" -o search_base.json
curl -sL -w "%{url_effective} %{http_code} %{time_total} %{size_download}\\n" $BASEURL"/getjson/getTmplNames/"$NETID"/favourites" -o favourites_base.json
curl -sL -w "%{url_effective} %{http_code} %{time_total} %{size_download}\\n" $BASEURL"/getjson/ads/"$NETID -o add_base.json

curl -sL -w "%{url_effective} %{http_code} %{time_total} %{size_download}\\n" $BASEURL"getjson/articles/"$NETID"/91015/" -o categoryarticles_base.json
cat categoryarticles_base.json | sed 's/,"timestamp":[0-9]*//g' > categoryarticles_baseremoveTime.json

curl -sL -w "%{url_effective} %{http_code} %{time_total} %{size_download}\\n" $BASEURL"getjson/articles/"$NETID"/91015/0/20" -o categoryarticlesfetch_base.json
cat categoryarticlesfetch_base.json | sed 's/,"timestamp":[0-9]*//g' > categoryarticlesfetch_baseremoveTime.json

curl -sL -w "%{url_effective} %{http_code} %{time_total} %{size_download}\\n" $BASEURL"getjson/articles/"$NETID"/91015/20/20" -o categoryarticlesfetch1_base.json
cat categoryarticlesfetch1_base.json | sed 's/,"timestamp":[0-9]*//g' > categoryarticlesfetch1_baseremoveTime.json

cd ..
