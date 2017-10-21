
plotTabPanel <- miniUI::miniTabPanel(
  "plot",
  icon = shiny::icon("bar-chart"),
  miniUI::miniContentPanel(
    padding = 8,
    scrollable = FALSE,
    shiny::fillRow(
      flex = c(NA, 1),
        shiny::fillCol(
          flex = c(1, NA),
          width = 120,
          shiny::fillPage(
            shiny::uiOutput("plot_type"),
            shiny::radioButtons(
              "config",
              label = "Configure...",
              choices = c("fields", "color", "size", "facet"),
              selected = "fields"
            ),
            shiny::conditionalPanel(
              "input.config == 'fields'",
              # shiny::helpText(shiny::strong('FIELDS')),
              shiny::uiOutput("xvar"),
              shiny::uiOutput("yvar")
            ),
            shiny::conditionalPanel(
              "input.config == 'color'",
              shinyWidgets::switchInput("color_mapping_enabled", label = "(aes)",
                                        value = FALSE, onLabel = "map",
                                        offLabel = "set"),
              shiny::conditionalPanel("input.color_mapping_enabled == false",
                                      shiny::uiOutput("color_set")),
              shiny::conditionalPanel("input.color_mapping_enabled == true",
                                      shiny::uiOutput("color_map"),
                                      shiny::uiOutput("color_discrete")),
              shiny::uiOutput("alpha")
            ),
            shiny::conditionalPanel(
              "input.config == 'size'",
              shiny::conditionalPanel(
                "input.plot_type == 'point'",
                shinyWidgets::switchInput("size_mapping_enabled", label = "(aes)",
                                          value = FALSE, onLabel = "map",
                                          offLabel = "set"),
                shiny::conditionalPanel("input.size_mapping_enabled == false",
                                        shiny::uiOutput("size_set")),
                shiny::conditionalPanel("input.size_mapping_enabled == true",
                                        shiny::uiOutput("size_map"))
              ),
              shiny::conditionalPanel(
                "input.plot_type == 'histogram'",
                shiny::numericInput("bins", "bins:", value = 30,
                                    min = 1, max = 1000),
                shiny::numericInput("binwidth", "bin width:", value = NA)
              )
            ),
            shiny::conditionalPanel(
              "input.config == 'facet'",
              # shiny::helpText(shiny::strong('FACET')),
              shiny::uiOutput("facet_row"),
              shiny::uiOutput("facet_col"),
              shiny::checkboxInput('facet_label', 'show field label',
                                   value = TRUE)
            )
          ),
          shiny::fillPage(
            tags$hr(),
            shiny::checkboxInput("show_code", "show code",
                                 value = FALSE),
            shiny::checkboxInput("auto_plot", "auto-update",
                                 value = TRUE),
            shiny::actionButton("btn_update", "update plot")
            )
        ),
      miniUI::miniContentPanel(
        padding = 5,
        shiny::fillCol(
          flex = c(NA, 1),
          shiny::conditionalPanel(
            "input.show_code == true",
              shiny::verbatimTextOutput("render_code_text")
          ),
          shiny::plotOutput("plot_display", height = "100%")
        )
      )
    )
  )
)
