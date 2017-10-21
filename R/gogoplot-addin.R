#' gogogplot_addin
#'
#' This is a wrapper around \code{gogoplot} to use as an RStudio addin. It
#' allows you to select an object (e.g. a data-frame) and then run the addin
#' in RStudio either via menu or a hotkey.
#'
#' @keywords internal
gogogplot_addin <- function() {
  # get the document context.
  context <- rstudioapi::getActiveDocumentContext()

  # set the default data to use based on the selection.
  text <- context$selection[[1]]$text

  # NOTE: previously re-created object in this environment with `assign`
  #       now, the object is referenced from the global environment
  # assign(text, get(text, envir = .GlobalEnv))
  rlang::eval_tidy(quo(gogoplot(!!sym(text))))
}
