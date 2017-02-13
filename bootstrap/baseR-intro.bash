#!/bin/bash
## Script that downloads
## some source data and iPython notebooks 
## into a Jupyter image for Python and Machine Learning course

cd /home/jovyan/work
# make directories
mkdir data

cd data
wget https://github.com/csc-training/R-for-beginners/raw/master/data/weather-kumpula.csv
cd ..
wget https://github.com/csc-training/R-for-beginners/raw/master/baseRintro.ipynb
