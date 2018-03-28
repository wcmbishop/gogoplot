# geom_histogram module

GeomHistogramInput <- function(id) {
  ns <- NS(id)

  tagList(
    shiny::radioButtons(ns("config"), label = "Configure...",
                        choices = c("fields", "fill", "bins", "facet"),
                        selected = "fields"
    ),
    shiny::conditionalPanel(sprintf("input['%s'] == 'fields'", ns("config")),
                            FieldsInput(ns("fields"), xvar = TRUE, yvar = FALSE)),
    shiny::conditionalPanel(sprintf("input['%s'] == 'fill'", ns("config")),
                            FillInput(ns("fill"))),
    shiny::conditionalPanel(sprintf("input['%s'] == 'bins'", ns("config")),
                            shiny::numericInput(ns("bins"), "bins:",
                                                value = CONST_DEFAULT_BINS,
                                                min = 1, max = 1000),
                            shiny::numericInput(ns("binwidth"), "bin width:",
                                                value = NA)),
    shiny::conditionalPanel(sprintf("input['%s'] == 'facet'", ns("config")),
                            FacetsInput(ns("facets")))
  )
}

GeomHistogram <- function(input, output, session, var_choices, data_name) {
  ns <- session$ns

  # input modules
  fields <- callModule(Fields, "fields", var_choices = var_choices)
  fill <- callModule(Fill, "fill", var_choices = var_choices)
  facets <- callModule(Facets, "facets", var_choices = var_choices)

  # custom inputs
  bins <- shiny::reactiveValues()
  shiny::observe({
    bins$bins <- input$bins
    bins$binwidth <- input$binwidth
  })

  # build base-plot
  p <- shiny::reactive({
    shiny::validate(
      shiny::need(fields$xvar, "  Select x variable."),
      shiny::need(fields$xvar != CONST_NONE, "  Select x variable.")
    )
    new_gogoplot(ggplot(!!sym(data_name), aes(!!sym(fields$xvar)))) %>%
      add_geom_histogram(fields, fill, bins)
  })

  # return list of reactive results
  return(list(plot = p, facets = facets))
}
