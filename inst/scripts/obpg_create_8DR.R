# usage: daily_creator [--] [--help] [--config_filename CONFIG_FILENAME] [--config_path CONFIG_PATH]
# [--root_data_path ROOT_DATA_PATH]
# 
# obpg daily creator
# 
# flags:
#   -h, --help             show this help message and exit
# 
# optional arguments:
#   -c, --config_filename  config_filename identifies the config
# file [default:
#         nwa_AQUA_9km_day_create.yaml]
# --config_path          path to config file [default: /home/btupper/R/x86_64-redhat-linux-gnu-library/4.4/obtools/config]
# -r, --root_data_path   the root data path [default: /mnt/s1/projects/ecocast/coredata/obpg2]


# builds 8DR rasters for NWA
#
# For each parameter
# ff = list of available files (named by date)
# dd = build a list of expected days (which may or may not match ff)
# dummy =  a dummy raster for missing days
# Make a queue of 8 days dummy, day1, day2, day7
# for each day
#   pop the first in
#   push the next day or dummy
#   make a stack by calculating mean and writing to file
#
TICK = Sys.time()
suppressPackageStartupMessages({
  library(argparser)
  library(obtools)
  library(obpg)
  library(charlier)
  library(dplyr)
  library(stars)
  library(rstackdeque)
})
concat  <- function(x) {
  if (!inherits(x, "list")) x = as.list(x)
  do.call(c, append(x, list(along = list(time = seq_along(x)))))
}
push    <- function(Q, x) insert_front(Q, x)
pop     <- function(Q)    without_back(Q)
advance <- function(Q, x) push(pop(Q), x)
avg     <- function(Q, filename) {
  stars::st_apply(concat(Q), seq.len(2),
                  mean,
                  na.rm = TRUE) |>
    stars::write_stars(filename)
}




create_one_param = function(tbl, key, cfg = NULL, path = NULL){
  
  tick = System.time()
  charlier::info("building %s", tbl$param[1])
  tbl = dplyr::arrange(tbl, date)
  ff      = obpg::compose_filename(tbl, path)
  DD      = tbl$date
  dr      = range(as.Date(tbl$date))
  dd      = seq(from = dr[1], to = dr[2], by = 'day')
  dummy   = stars::read_stars(ff[1])
  dummy[[1]] = NA_real_
  # make the Q and prepopulate
  Q       = rstackdeque::rdeque()
  Q       = push(Q, dummy)
  for (i in seq_len(7)) {
    Q = push(Q, if (dd[i] %in% DD) stars::read_stars(ff[i]) else dummy)
  }
  N = length(dd)
  for (i in seq(from = 8, to = 30)){
    Q <- advance(Q, if (dd[i] %in% DD) stars::read_stars(ff[i]) else dummy)
    ofile <- obpg::compose_filename(tbl |>
                                        dplyr::slice(i) |>
                                        dplyr::mutate(per = '8DR'),
                                      path,
                                      from_scratch = TRUE)
    charlier::info("%0.2f%% %s", i/N * 100, basename(ofile))
    S <- avg(Q, filename = ofile) 
  }
  
  tock = System.time()
  elapsed = tock - tick
  if (!is.null(cfg$email)) {
    charlier::sendmail(to = cfg$email, subject = paste("obpg_create_8DR", tbl$param[1]),
                        message =sprintf("is done in %0.3f %s!", as.numeric(elapsed), units(elapsed)))
  }
}

main = function(cfg, root = "."){
  
  data_path = file.path(root, cfg$name, cfg[['path']])
  
  charlier::start_logger(file.path(data_path, "log"))
  
  DB = read_database(data_path) |>
    dplyr::filter(per == "DAY") |>
    dplyr::group_by(param) |>
    dplyr::group_map(create_one_param, .keep = TRUE, cfg = cfg, path = data_path)
  
  obpg::build_database(path, save_db = TRUE)
}


args = argparser::arg_parser("obpg daily creator",
                             name = "daily_creator",
                             hide.opts = TRUE) |>
  argparser::add_argument("--config_filename",
                          help = "config_filename identifies the config file",
                          default = "nwa_AQUA_4km_8DR_create.yaml",
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



TOCK = Sys.time()
ELAPSED = TOCK - TICK
if (!is.null(EMAIL)) rscripting::sendmail(to = EMAIL, sbj = "build_obpg_8DR",
                                          msg = format(ELAPSED))