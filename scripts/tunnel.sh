#!/bin/sh
ssh -v -i /root/.ssh/gcocd -Ng -L 3344:0.0.0.0:27017 guillem@ec2-52-40-19-99.us-west-2.compute.amazonaws.com;
