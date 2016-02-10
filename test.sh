#!/usr/bin/env bash

ORIGIN=https://williamkapke:$GITHUB_TOKEN@github.com/williamkapke/node-compat-table.git

echo
echo 'downloading latest...'
rm -rf ./.temp
git clone $ORIGIN .temp

mkdir -p ./.temp/results
cd ./.temp
git config user.email "william.kapke@gmail.com"
git config user.name "William Kapke"
curl https://raw.githubusercontent.com/kangax/compat-table/gh-pages/data-es6.js > data-es6.js

echo
echo 'extracting testers...'
node extract.js > ./testers.json


echo
echo 'running the tests on each version of node...'
while read v; do
  n use $v --es_staging test.js
done < .versions



if [[ `git status -s` == '' ]]; then
  echo 'No changes';
  exit 1;
fi

echo
echo 'building webpage...'
node build.js

echo
echo 'saving the results...'
git commit -am 'Auto Update'
git push $ORIGIN gh-pages

