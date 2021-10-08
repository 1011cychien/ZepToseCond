#!/usr/bin/env bash
set -ex

if [ -z ${GITHUB_TOKEN+x} ]; then
  if [ -z ${1+x} ]; then
    echo "GITHUB_TOKEN not present, the first argument should be the token"
    exit 1  
  fi
  GITHUB_TOKEN=$1
fi

git config --global user.name "Chris Chien (Built with Travis-CI)"
git config --global user.email "chris.89357@gmail.com"

git clone https://github.com/1011cychien/ZepToseCond.git --branch master --single-branch /master/
cd /master/codebook

if [ -f codebook.pdf ]; then
    rm codebook.pdf
fi

xelatex codebook.tex && xelatex codebook.tex && xelatex codebook.tex
mv codebook.pdf codebook.default.pdf

# test clang-format
clang-format-13 -i [23456789]_*/*.cpp
xelatex codebook.tex && xelatex codebook.tex && xelatex codebook.tex
mv codebook.pdf codebook.test.pdf

curtime=$(date +"%Y-%m-%d_%H:%M:%S")

echo "Current time is: $curtime."

git clone https://1011cychien:$GITHUB_TOKEN@github.com/1011cychien/ZepToseCond.git --branch codebook --single-branch /codebook/

cp codebook.default.pdf /codebook/codebook.pdf
cp codebook.test.pdf /codebook/codebook.test.pdf
cd /codebook/

git add .
git commit -m "Auto build, $curtime"
git push origin codebook

echo "Build Done."
