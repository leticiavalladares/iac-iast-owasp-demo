#!/bin/bash

yum update -y
yum install -y docker
service docker start
docker pull lavf/juicydemo
docker run -d -p 80:3000 lavf/juicydemo

# vi env.list
#docker run --rm -p 3000:3000 --env-file env.list public.ecr.aws/m5o8t9w4/juice-shop:mysql