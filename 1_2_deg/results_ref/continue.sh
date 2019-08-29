#!/bin/bash

rm *.nc fesom.clock ./newdata/*.nc ./plots/*.png ./animations/*.mp4

cp ../results_spinup/fesom.1967.oce.restart.nc .
cp ../results_spinup/fesom.clock .
