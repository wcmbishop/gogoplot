add_facet_grid <- function(p, input) {
  # validate inputs
  req_inputs <- c("facet_row", "facet_col", "facet_label")
  if (!all(req_inputs %in% names(input)))
    stop("some required input fields are missing")
  if (!(is.logical(input$facet_label)))
    stop("facet_label must be a logical value")

  if (any(c(input$facet_row, input$facet_col) != CONST_NONE)) {
    facet_lab_expr <- if_else_expr(input$facet_label == TRUE,
                                   rlang::expr(label_both),
                                   rlang::expr(label_value))
    facet_row <- ifelse(input$facet_row == CONST_NONE, ".", input$facet_row)
    facet_col <- ifelse(input$facet_col == CONST_NONE, ".", input$facet_col)
    p <- p %++% facet_grid(!!sym(facet_row) ~ !!sym(facet_col),
                           labeller = !!(facet_lab_expr))
  }
  p
}
