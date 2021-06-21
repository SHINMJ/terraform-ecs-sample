#!/bin/bash

cd /home/ubuntu/build/app

sudo docker build -t testapp:latest .
sudo docker run -d -p 8000:8000 -it --detach --name testapp testapp:latest 

