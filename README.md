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

- [update_obpg.R](inst/scripts/obpg_update.R)
