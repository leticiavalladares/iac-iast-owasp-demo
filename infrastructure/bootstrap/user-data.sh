#!/bin/bash

sudo apt-get update
sudo apt-get install git -y
sudo apt-get install docker.io -y

git clone --branch mysql https://github.com/harrykimpel/juice-shop.git
cd juice-shop
git checkout 
# vi env.list
#docker run --rm -p 3000:3000 --env-file env.list public.ecr.aws/m5o8t9w4/juice-shop:mysql