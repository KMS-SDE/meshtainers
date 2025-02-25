#!/bin/sh

if [ -e /tmp/cpt4.jar ] 
then
echo "Building CPT4"
java -Dumls-apikey=$1 -jar /tmp/cpt4.jar 5
else
echo "No cpt4.jar found. Skipped build"
fi
