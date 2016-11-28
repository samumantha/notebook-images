#!/bin/bash
## Script that downloads
## some source data and iPython notebooks 
## into a Jupyter image for Python and Machine Learning course

cd /home/jovyan/work
# make directories
mkdir -p data/hml

cd data
wget https://vincentarelbundock.github.io/Rdatasets/csv/ISLR/Wage.csv
wget https://vincentarelbundock.github.io/Rdatasets/csv/car/Davis.csv
wget https://raw.githubusercontent.com/CSC-IT-Center-for-Science/data-stat-course/master/datasets/weather-kumpula.csv
wget https://archive.ics.uci.edu/ml/machine-learning-databases/auto-mpg/auto-mpg.data
wget https://archive.ics.uci.edu/ml/machine-learning-databases/00320/student.zip
wget https://archive.ics.uci.edu/ml/machine-learning-databases/wine-quality/winequality-white.csv
cd hml
wget http://www.hameenlinna.fi/pages/563719/Ostolaskut/2014/HML%20ostolaskut%202014%20julkaisu%20csv.zip
unzip *.zip
rm *.zip
cd ../..
wget https://csc-it-center-for-science.github.io/python-data/notebooks/demo/estimate.py
wget https://csc-it-center-for-science.github.io/python-data/notebooks/demo/hml_laskudata.ipynb
wget https://csc-it-center-for-science.github.io/python-data/notebooks/demo/creating_a_classifier.ipynb
wget https://csc-it-center-for-science.github.io/python-data/notebooks/demo/Regression.ipynb
