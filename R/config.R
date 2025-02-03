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
#' @return configuration list
read_configuration = function(filename = "nwa_AQUA_day.yaml",
                              path = config_path()){
  file = file.path(path, filename)
  if (!file.exists(file)){
    stop("config file not found: ", file)
  }
  yaml::read_yaml(file)
}
