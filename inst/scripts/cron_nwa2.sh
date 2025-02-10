#!/bin/bash

# Runs regular downloads of OBPG nwa2 data sets
# and subsequent processing (8DR, 16DR, 32DR, gradients, ...)

opts="--no-save --no-restore"
path="/mnt/s1/projects/ecocast/corecode/R/obtools/inst/scripts/"


Rscript ${opts} ${path}/obpg_create.R --config_filename "nwa_AQUA_4km_day_update.yaml" 



#Rscript ${opts} ${path}nwa2_daily_fetch.R --mit AQUA_MODIS
#Rscript ${opts} ${path}nwa2_update_8DR.R --mit AQUA_MODIS
#Rscript ${opts} ${path}nwa2_update_gradient.R --mit AQUA_MODIS
#Rscript ${opts} ${path}nwa2_update_xDR.R --window 16DR --mit AQUA_MODIS
#Rscript ${opts} ${path}nwa2_update_xDR.R --window 32DR --mit AQUA_MODIS
## Rscript ${opts} ${path}nwa2_update_fill.R --mit AQUA_MODIS
## Rscript ${opts} ${path}nwa2_update_cum.R --mit AQUA_MODIS
#
#Rscript ${opts} ${path}nwa2_daily_fetch.R --mit TERRA_MODIS
#Rscript ${opts} ${path}nwa2_update_8DR.R --mit TERRA_MODIS
#Rscript ${opts} ${path}nwa2_update_gradient.R --mit TERRA_MODIS
#Rscript ${opts} ${path}nwa2_update_xDR.R --window 16DR --mit TERRA_MODIS
#Rscript ${opts} ${path}nwa2_update_xDR.R --window 32DR --mit TERRA_MODIS
## Rscript ${opts} ${path}nwa2_update_fill.R --mit TERRA_MODIS
## Rscript ${opts} ${path}nwa2_update_cum.R --mit TERRA_MODIS