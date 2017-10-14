
select_choices <- function(.data) {
  # name choices with: "name (type)"
  var_types <- vapply(.data, tibble::type_sum, character(1))
  x <- c(CONST_NONE, names(var_types))
  names(x) <- c("choose...", sprintf("%s (%s)", names(var_types), var_types))
  x
}
