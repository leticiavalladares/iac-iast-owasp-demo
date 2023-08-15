#!/bin/bash

yum update -y
yum install -y docker
git clone -b mysql https://github.com/harrykimpel/juice-shop.git
service docker start
cd juice-shop
#vi env.list
#docker run --rm -p 3000:3000 --env-file env.list public.ecr.aws/m5o8t9w4/juice-shop:mysql


#docker pull lavf/juicydemo
#docker run -d -p 80:3000 lavf/juicydemo