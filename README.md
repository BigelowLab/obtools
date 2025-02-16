obtools
================

Extra R-language tools to supplement [obpg R
package](https://github.com/BigelowLab/obpg). This package serves up R
scripts to create a local data repository, or to update a local data
repository on a regular basis.

# Requirements for package

- [R v4.1+](https://www.r-project.org/)
- [yaml](https://CRAN.R-project.org/package=yaml)

# Requirements for scripts

The scripts can be pretty much anything that suits your needs. The
default scripts that come with this package do require some packages
which are listed here.

- [obpg](https://github.com/BigelowLab/obpg)
- [argparser](https://CRAN.R-project.org/package=argparser)
- [dplyr](https://CRAN.R-project.org/package=dplyr)
- [stars](https://CRAN.R-project.org/package=stars)
- [sf](https://CRAN.R-project.org/package=sf)

# Scripts

- [update_obpg.R](inst/scripts/obpg_update.R) is used to update a
  particular data set by examining the existising database. It then
  attempts to fetch files on the server server that are newer than the
  most recent database record. It works for multiple parameters, but one
  resolution/region/instrument at a time. It draws upon a configuration
  [such as this one](inst/config/nwa_AQUA_4km_day.yaml).
