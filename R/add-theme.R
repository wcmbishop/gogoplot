add_theme <- function(p, theme) {
  if (theme$base_size == CONST_DEFAULT_THEME_BASE_SIZE) {
    if (theme$theme != CONST_DEFAULT_THEME)
      p <- p %++% !!call2(sym(theme$theme))
  } else {
    p <- p %++% !!call2(sym(theme$theme), base_size = as.numeric(theme$base_size))
  }

  p
}
