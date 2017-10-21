add_facet_grid <- function(p, input) {
  # validate inputs
  req_inputs <- c("facet_row", "facet_col", "facet_label")
  if (!all(req_inputs %in% names(input)))
    stop("some required input fields are missing")
  if (!(is.logical(input$facet_label)))
    stop("facet_label must be a logical value")

  if (any(c(input$facet_row, input$facet_col) != CONST_NONE)) {
    label_expr <- rlang::exprs()
    if (input$facet_label)
      label_expr <- append_exprs(label_expr, labeller = label_both)
    facet_row <- ifelse(input$facet_row == CONST_NONE, ".", input$facet_row)
    facet_col <- ifelse(input$facet_col == CONST_NONE, ".", input$facet_col)
    p <- p %++% facet_grid(!!sym(facet_row) ~ !!sym(facet_col),
                           !!!label_expr)
  }
  p
}
