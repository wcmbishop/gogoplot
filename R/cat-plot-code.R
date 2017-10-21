cat_plot_code <- function(p) {
  if (!inherits(p, "ggplot"))
    stop("input must be a ggplot2 object")
  cat(
    paste0(get_plot_code(p), collapse = " +\n  ")
  )
}
