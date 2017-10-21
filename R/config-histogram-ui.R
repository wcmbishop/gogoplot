config_histogram_color <- shiny::conditionalPanel(
  "input.plot_type == 'histogram'",
  shinyWidgets::switchInput("color_mapping_enabled", label = "(aes)",
                            value = FALSE, onLabel = "map",
                            offLabel = "set"),
  shiny::conditionalPanel("input.color_mapping_enabled == false",
                          shiny::uiOutput("color_set")),
  shiny::conditionalPanel("input.color_mapping_enabled == true",
                          shiny::uiOutput("color_map"),
                          shiny::uiOutput("color_discrete")),
  shiny::uiOutput("alpha")
)
