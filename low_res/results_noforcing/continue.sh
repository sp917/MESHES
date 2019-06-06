#!/bin/bash

rm *.nc fesom.clock ./newdata/*.nc

cp ../results_std/fesom.1957.oce.restart.nc .
cp ../fesom.clock .
