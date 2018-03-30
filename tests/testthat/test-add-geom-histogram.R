context("add_geom_histogram")

p_blank <- new_gogoplot(ggplot(mtcars, aes(disp)))
default_fields <- list()
default_fill <- list(fill_map = CONST_NONE, fill_set = CONST_NONE,
                     fill_discrete = FALSE, fill_mapping_enabled = FALSE,
                     alpha = 1)
default_bins <- list(bins = CONST_DEFAULT_BINS, binwidth = NA_real_)


test_that("default settings", {
  fields <- default_fields
  fill <- default_fill
  bins <- default_bins
  p <- add_geom_histogram(p_blank, fields, fill, bins)
  code <- get_plot_code(p)
  expect_is(p, "ggplot")
  expect_equal(length(code), 2)
  expect_equal(code[2], "geom_histogram()")
})

# ---- alpha ----

test_that("set alpha", {
  fields <- default_fields
  fill <- default_fill
  bins <- default_bins
  fill$alpha <- 0.5
  p <- add_geom_histogram(p_blank, fields, fill, bins)
  code <- get_plot_code(p)
  expect_equal(code[2], "geom_histogram(alpha = 0.5)")
})

# ---- fill ----

test_that("map fill continuous", {
  fields <- default_fields
  fill <- default_fill
  bins <- default_bins
  fill$fill_mapping_enabled <- TRUE
  fill$fill_map <- "cyl"
  p <- add_geom_histogram(p_blank, fields, fill, bins)
  code <- get_plot_code(p)
  expect_equal(code[2], "geom_histogram(aes(fill = cyl))")
})

test_that("map fill discrete", {
  fields <- default_fields
  fill <- default_fill
  bins <- default_bins
  fill$fill_mapping_enabled <- TRUE
  fill$fill_map <- "cyl"
  fill$fill_discrete <- TRUE
  p <- add_geom_histogram(p_blank, fields, fill, bins)
  code <- get_plot_code(p)
  expect_equal(code[2], "geom_histogram(aes(fill = as.factor(cyl)))")
})

test_that("set fill", {
  fields <- default_fields
  fill <- default_fill
  bins <- default_bins
  fill$fill_set <- "blue"
  p <- add_geom_histogram(p_blank, fields, fill, bins)
  code <- get_plot_code(p)
  expect_equal(code[2], "geom_histogram(fill = \"blue\")")
})

# ---- bins ----

test_that("set bins", {
  fields <- default_fields
  fill <- default_fill
  bins <- default_bins
  bins$bins = 40
  p <- add_geom_histogram(p_blank, fields, fill, bins)
  code <- get_plot_code(p)
  expect_equal(code[2], "geom_histogram(bins = 40)")
})

test_that("set binwidth", {
  fields <- default_fields
  fill <- default_fill
  bins <- default_bins
  bins$binwidth = 10
  p <- add_geom_histogram(p_blank, fields, fill, bins)
  code <- get_plot_code(p)
  expect_equal(code[2], "geom_histogram(binwidth = 10)")
})

# ---- bade inputs ----

test_that("missing input field", {
  fields <- default_fields
  fill <- default_fill
  bins <- default_bins
  fill$fill_map <- NULL
  expect_error(add_geom_histogram(p_blank, fields, fill, bins),
               "fields are missing")
})

