# usage: daily_backfiller [--] [--help] [--config_filename CONFIG_FILENAME] [--config_path CONFIG_PATH]
#          [--root_data_path ROOT_DATA_PATH]
# 
# obpg daily backfiller
# 
# flags:
#   -h, --help             show this help message and exit
# 
# optional arguments:
#   -c, --config_filename  config_filename identifies the config file [default: nwa_AQUA_9km_day_backfill.yaml]
#   --config_path          path to config file [default: /Library/Frameworks/R.framework/Versions/4.4-x86_64/Resources/library/obtools/config]
#   -r, --root_data_path   the root data path [default: /Users/ben/Dropbox/data/obpg]



suppressPackageStartupMessages({
  library(argparser)
  library(dplyr)
  library(sf)
  library(stars)
  library(obpg)
  library(obtools)
})

# This accepts a table of one group to update
backfill_one_param = function(tbl, key, cfg = NULL, path = NULL){
  most_recent = db_most_recent(tbl)
  dates = seq(from = as.Date(cfg$start_date), to = most_recent$date[1], by = tolower(cfg$period))
  tibble(date = dates[!(dates %in% tbl$date)]) |>
    dplyr::rowwise() |>
    dplyr::group_map(
      function(tab, key, cfg = NULL, template = NULL){
        uri =  obpg::obpg_url(date = dplyr::pull(tab),
                              mission = cfg$mission, 
                              instrument = cfg$instrument,
                              product = paste(template$suite, template$param, sep = "."),
                              period = cfg$period,
                              resolution = cfg$resolution)
        obpg::fetch_obpg(uri, bb = unlist(cfg$bb), path = path)
      }, cfg = cfg, template = dplyr::slice(tbl,1)) |>
    dplyr::bind_rows()
}


# this the main function that sets up the loop for downloading
main = function(cfg, root = obtools::obpg_path()){
  
  data_path = file.path(root, cfg$name, cfg[['path']])
  DB = read_database(data_path)
  DB |>
    dplyr::filter(.data$param %in% cfg$param,
                  .data$res %in% cfg$resolution) |>
    dplyr::arrange(date) |>
    dplyr::group_by(param) |>
    dplyr::group_map(backfill_one_param, .keep = TRUE, cfg = cfg, path = data_path) |>
    dplyr::bind_rows() |>
    obpg::write_database(data_path, append = TRUE)
  
}

args = argparser::arg_parser("obpg daily backfiller",
                             name = "daily_backfiller",
                             hide.opts = TRUE) |>
  argparser::add_argument("--config_filename",
                          help = "config_filename identifies the config file",
                          default = "nwa_AQUA_9km_day_backfill.yaml",
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

if (!interactive()) quit(save = "no", status = 0)


