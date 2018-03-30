# geom_line module

GeomLineInput <- function(id) {
  ns <- NS(id)

  tagList(
    shiny::radioButtons(ns("config"), label = "Configure...",
                        choices = c("fields", "color", "size", "group", "facet"),
                        selected = "fields"
    ),
    shiny::conditionalPanel(sprintf("input['%s'] == 'fields'", ns("config")),
                            FieldsInput(ns("fields"), xvar = TRUE, yvar = TRUE)),
    shiny::conditionalPanel(sprintf("input['%s'] == 'color'", ns("config")),
                            ColorInput(ns("color"))),
    shiny::conditionalPanel(sprintf("input['%s'] == 'size'", ns("config")),
                            SizeInput(ns("size"))),
    shiny::conditionalPanel(sprintf("input['%s'] == 'group'", ns("config")),
                            GroupInput(ns("group"))),
    shiny::conditionalPanel(sprintf("input['%s'] == 'facet'", ns("config")),
                            FacetsInput(ns("facets")))
  )
}

GeomLine <- function(input, output, session, var_choices, data_name) {
  ns <- session$ns

  # input modules
  fields <- callModule(Fields, "fields", var_choices = var_choices)
  color <- callModule(Color, "color", var_choices = var_choices)
  size <- callModule(Size, "size", var_choices = var_choices,
                     default_size = CONST_DEFAULT_LINE_SIZE)
  group <- callModule(Group, "group", var_choices = var_choices)
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
                        aes(!!sym(fields$xvar), !!sym(fields$yvar)))) %>%
      add_geom_line(fields, size, color, group)
  })

  # return list of reactive results
  return(list(plot = p, facets = facets))
}
