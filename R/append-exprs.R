append_exprs <- function(x, ...) {
  x <- rlang::exprs(rlang::UQS(x), ...)
  x
}
