#' Get, set and build OBPG paths
#' 
#' 
#' @param root chr the root OBPG data path
#' @param filename chr the filename where we store the path
#' @param ... file path segments passed to [file.path]
#' @return a file or directory path description
#' @name obpg_path
NULL

#' @export
#' @rdname obpg_path
set_obpg_root = function(root = ".", filename = "~/.obtools"){
  cat(root, sep = "\n", file = filename)
  invisible(root)
}

#' @export
#' @rdname obpg_path
get_obpg_root = function(filename = "~/.obtools"){
  readLines(filename)
}

#' @export
#' @rdname obpg_path
obpg_path = function(..., 
                     root = get_obpg_root()){
  file.path(root, ...)
}
