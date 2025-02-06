#' Retrieve the configurations path included with the package
#' 
#' @export
#' @return configuration path
config_path = function(){
  system.file("config", package = "obtools")
}


#' Read a configuration
#' 
#' @export
#' @param filename chr the name of the file
#' @param path chr the path to th configuration
#' @param add_param logical, if TRUE then process the PRODUCT line into 
#'   suite and param
#' @return configuration list
read_configuration = function(filename = "nwa_AQUA_day.yaml",
                              add_param = TRUE,
                              path = config_path()){
  file = file.path(path, filename)
  if (!file.exists(file)){
    stop("config file not found: ", file)
  }
  x = yaml::read_yaml(file)
  if (add_param) x = parse_param(x)
  x
}


#' Parse the "product" element of a config list to yield a new "param" and "suite" element
#' 
#' @export
#' @param x configuration list
#' @return the input list with "param" added if possible
parse_param = function(x){
  if ("product" %in% names(x)){
    pp = strsplit(x$product, ".", fixed = TRUE)
    x$param = sapply(pp, "[", 2)   # param
    x$suite = sapply(pp, "[", 1)   # suite
  }
  x
} 