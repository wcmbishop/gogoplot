add_geom_point <- function(p, input) {
  # validate inputs
  req_inputs <- c("alpha", "color", "color_scale",
                  "size_type", "size_map", "size_set")
  if (!all(req_inputs %in% names(input)))
    stop("some required input fields are missing")
  if (!(input$size_type %in% c("map", "set")))
    stop("size_type must be either 'map' or 'set'")
  if (!(input$color_scale %in% c("discrete", "continuous")))
    stop("color_scale must be either 'discrete' or 'continuous'")

  # prep color quo
  if (input$color_scale == "discrete") {
    quo_color <- quo(as.factor(!!sym(input$color)))
  } else {
    quo_color <- quo(!!sym(input$color))
  }

  # build geom_point for each combination of inputs
  if (input$color == "none" && input$size_type == "set") {
    # no color, set size
    p <- p %++% geom_point(size = !!input$size_set,
                           alpha = !!input$alpha)

  } else if (input$color == "none" && input$size_type == "map") {
    # no color, map size
    if (input$size_map == "none") {
      # no size
      p <- p %++% geom_point(alpha = !!input$alpha)
    } else {
      # map size
      p <- p %++% geom_point(aes(size = !!sym(input$size_map)),
                             alpha = !!input$alpha)
    }

  } else if (input$color != "none" && input$size_type == "set") {
    # map color, set size
    p <- p %++% geom_point(aes(color = UQE(quo_color)),
                           size = !!input$size_set,
                           alpha = !!input$alpha)

  } else if (input$color != "none" && input$size_type == "map") {
    # map color, map size
    if (input$size_map == "none") {
      # no size
      p <- p %++% geom_point(aes(color = UQE(quo_color)),
                             alpha = !!input$alpha)
    } else {
      # map size
      p <- p %++% geom_point(aes(color = UQE(quo_color),
                                 size = !!sym(input$size_map)),
                             alpha = !!input$alpha)
    }

  } else {
    stop("ruh-roh...unexpected inputs encountered")
  }
  p
}
