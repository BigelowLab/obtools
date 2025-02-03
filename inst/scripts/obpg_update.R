# usage: daily_download [--] [--help] [--config_filename
#                                      CONFIG_FILENAME] [--config_path CONFIG_PATH] [--root_data_path
#                                                                                    ROOT_DATA_PATH]
# 
# obpg daily downloads
# 
# flags:
#   -h, --help             show this help message and exit
# 
# optional arguments:
#   -c, --config_filename  config_filename identifies the config file
# [default: nwa_AQUA_day.yaml]
# --config_path          path to config file [default: /Library/Frameworks/R.framework/Versions/4.4-x86_64/Resources/library/obtools/config]
# -r, --root_data_path   the root data path [default:  /Users/ben/Dropbox/data/obpg]



suppressPackageStartupMessages({
  library(argparser)
  library(dplyr)
  library(sf)
  library(stars)
  library(obpg)
  library(obtools)
})

main = function(cfg, root = obtools::obpg_path()){
  bb = cfg[['bb']] |> unlist()
  data_path = file.path(root, cfg$name, cfg[['path']])
  DB = read_database(data_path)
  
}

args = argparser::arg_parser("obpg daily downloads",
                             name = "daily_download",
                             hide.opts = TRUE) |>
  argparser::add_argument("--config_filename",
                          help = "config_filename identifies the config file",
                          default = "nwa_AQUA_day.yaml",
                          ) |>
  argparser::add_argument("--config_path",
                          help = "path to config file",
                          default = obtools::config_path()) |>
  argparser::add_argument("--root_data_path",
                          help = "the root data path",
                          default = obtools::get_obpg_root()) |>
  argparser::parse_args()

cfg = obtools::read_configuration(args$config_filename, path = args$config_path)
root = args$root_data_path
ok = main(cfg, root = root)

if (!interactive()) quit(save = no, status = ok)


