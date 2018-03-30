# geom_line module

GeomBoxplotInput <- function(id) {
  ns <- NS(id)

  tagList(
    shiny::radioButtons(ns("config"), label = "Configure...",
                        choices = c("fields", "color", "fill", "facet"),
                        selected = "fields"
    ),
    shiny::conditionalPanel(sprintf("input['%s'] == 'fields'", ns("config")),
                            FieldsInput(ns("fields"), xvar = TRUE, yvar = TRUE)),
    shiny::conditionalPanel(sprintf("input['%s'] == 'color'", ns("config")),
                            ColorInput(ns("color"), show_alpha = FALSE)),
    shiny::conditionalPanel(sprintf("input['%s'] == 'fill'", ns("config")),
                            FillInput(ns("fill"))),
    shiny::conditionalPanel(sprintf("input['%s'] == 'facet'", ns("config")),
                            FacetsInput(ns("facets")))
  )
}

GeomBoxplot <- function(input, output, session, var_choices, data_name) {
  ns <- session$ns

  # input modules
  fields <- callModule(Fields, "fields", var_choices = var_choices)
  color <- callModule(Color, "color", var_choices = var_choices)
  fill <- callModule(Fill, "fill", var_choices = var_choices)
  facets <- callModule(Facets, "facets", var_choices = var_choices)

  # build base-plot
  p <- shiny::reactive({
    shiny::validate(
      shiny::need(fields$xvar, "  Select x variable."),
      shiny::need(fields$yvar, "  Select y variable."),
      shiny::need(fields$xvar != CONST_NONE, "  Select x variable."),
      shiny::need(fields$yvar != CONST_NONE, "  Select y variable.")
    )
    new_gogoplot(ggplot(!!sym(data_name),
                        aes(as.factor(!!sym(fields$xvar)), !!sym(fields$yvar)))) %>%
      add_geom_boxplot(fields = fields, color = color, fill = fill)
  })

  # return list of reactive results
  return(list(plot = p, facets = facets))
}
