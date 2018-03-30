add_geom_histogram <- function(p, fields, fill, bins) {
  # validate fill inputs
  req_fill_inputs <- c("alpha", "fill_mapping_enabled", "fill_map", "fill_set")
  if (!all(req_fill_inputs %in% names(fill)))
    stop("some required fill input fields are missing")
  if (!is.logical(fill$fill_mapping_enabled))
    stop("fill_mapping_enabled must be a logical value")
  # validate bins inputs
  req_bins_inputs <- c("bins", "binwidth")
  if (!all(req_bins_inputs %in% names(bins)))
    stop("some required bins input fields are missing")

  mapping <- rlang::exprs()
  setting <- rlang::exprs()

  # FILL
  if (fill$fill_mapping_enabled) {
    if (fill$fill_map != CONST_NONE) {
      fill_expr <- if_else_expr(fill$fill_discrete == TRUE,
                                 rlang::expr(as.factor(!!sym(fill$fill_map))),
                                 rlang::expr(!!sym(fill$fill_map)))
      mapping <- append_exprs(mapping, fill = !!(fill_expr))
    }
  } else {
    if (fill$fill_set != CONST_NONE)
      setting <- append_exprs(setting, fill = !!fill$fill_set)
  }

  # ALPHA
  if (fill$alpha != 1)
    setting <- append_exprs(setting, alpha = !!as.numeric(fill$alpha))

  # BINS
  if (is.na(bins$binwidth)) {
    if (bins$bins != CONST_DEFAULT_BINS)
      setting <- append_exprs(setting, bins = !!as.numeric(round(bins$bins)))
  } else {
    setting <- append_exprs(setting, binwidth = !!bins$binwidth)
  }

  # compile expressions into layer
  if (length(mapping) > 0) {
    p <- p %++% geom_histogram(aes(!!!mapping), !!!setting)
  } else {
    p <- p %++% geom_histogram(!!!setting)
  }
  p
}
