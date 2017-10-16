if_else_expr <- function(condition,  true, false) {
  if (!is.logical(condition))
    stop("'condition' must be a logical value.")
  if (length(condition) != 1)
    stop("'condition' must be length 1.")

  if (condition) {
    out <- true
  } else {
    out <- false
  }
  out
}
