#!/bin/bash
# Commands to run in the background at startup
# Tom Zaki
# 02.07.2013

cd /home/public/public/
find . -type d -exec cp -u index.php {} \;
chmod -R 777 /home/public/public/
chown -R public:public /home/public/public/
