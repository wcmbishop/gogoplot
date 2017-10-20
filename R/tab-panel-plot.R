
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
          shiny::fillCol(
            flex = c(NA),
            shiny::uiOutput("plot_type"),
            shiny::radioButtons(
              "config",
              label = "Configure...",
              choices = c("fields", "color", "size", "facets", "scales"),
              selected = "fields"
            ),
            shiny::conditionalPanel(
              "input.config == 'fields'",
              shiny::helpText(shiny::strong('FIELDS')),
              shiny::uiOutput("xvar"),
              shiny::uiOutput("yvar")
            ),
            shiny::conditionalPanel(
              "input.config == 'color'",
              shiny::helpText(shiny::strong('COLOR')),
              shiny::uiOutput("color"),
              shiny::checkboxInput('legend', 'show legend', value = TRUE),
              shiny::radioButtons(
                'color_scale',
                NULL,
                choices = c('discrete', 'continuous'),
                selected = 'continuous'
              ),
              shiny::uiOutput("alpha")
            ),
            shiny::conditionalPanel(
              "input.config == 'size'",
              shiny::helpText(shiny::strong('SIZE')),
              shinyWidgets::switchInput("size_mappping_enabled", label = "map",
                                        value = FALSE, onLabel = "ON",
                                        offLabel = "OFF"),
              shiny::conditionalPanel("input.size_mappping_enabled == false",
                                      shiny::uiOutput("size_set")),
              shiny::conditionalPanel("input.size_mappping_enabled == true",
                                      shiny::uiOutput("size_map"))
            ),
            shiny::conditionalPanel(
              "input.config == 'facets'",
              shiny::helpText(shiny::strong('FACET')),
              shiny::uiOutput("facet_row"),
              shiny::uiOutput("facet_col"),
              shiny::checkboxInput('facet_label', 'show field label',
                                   value = TRUE)
            ),
            shiny::conditionalPanel(
              "input.config == 'scales'",
              shiny::helpText(shiny::strong('SCALES')),
              shiny::helpText("coming soon.")
            )
          ),
          shiny::fillCol(
            flex = c(NA, NA, NA),
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
