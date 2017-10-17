add_geom_histogram <- function(p, input) {
  # validate inputs
  req_inputs <- c("alpha")
  if (!all(req_inputs %in% names(input)))
    stop("some required input fields are missing")

  # build up list of "mapping" and "setting" expressions
  # which will go into a ggplot2 layer at the end
  mapping <- rlang::exprs()
  setting <- rlang::exprs()

  # COLOR
  # tbd...

  # ALPHA
  setting <- append_exprs(setting, alpha = !!as.numeric(input$alpha))

  # SIZE
  # tbd...

  # compile expressions into layer
  if (length(mapping) > 0) {
    p <- p %++% geom_histogram(aes(!!!mapping), !!!setting)
  } else {
    p <- p %++% geom_histogram(!!!setting)
  }
  p
}
