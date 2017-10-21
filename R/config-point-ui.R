config_point_size <- shiny::conditionalPanel(
  "input.plot_type == 'point'",
  # shiny::helpText(shiny::strong('SIZE')),
  shinyWidgets::switchInput("size_mapping_enabled", label = "(aes)",
                            value = FALSE, onLabel = "map",
                            offLabel = "set"),
  shiny::conditionalPanel("input.size_mapping_enabled == false",
                          shiny::uiOutput("size_set")),
  shiny::conditionalPanel("input.size_mapping_enabled == true",
                          shiny::uiOutput("size_map"))
)

config_point_color <- shiny::conditionalPanel(
  "input.plot_type == 'point'",
  # shiny::helpText(shiny::strong('COLOR')),
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

