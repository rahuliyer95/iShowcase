#!/usr/bin/env bash
git clone https://www.github.com/rahuliyer95/ishowcase -b gh-pages gh-pages
rm -rf gh-pages/*
jazzy --podspec iShowcase.podspec --output gh-pages
cp -r ./assets gh-pages/
cd gh-pages
git add .
git commit -m "docs update"
git push origin gh-pages
cd ..
rm -rf gh-pages
