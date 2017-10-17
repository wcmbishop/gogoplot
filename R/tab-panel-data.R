dataTabPanel <- miniUI::miniTabPanel(
  "data",
  icon = shiny::icon("database"),
  miniUI::miniContentPanel(
    padding = 10,
    shiny::dataTableOutput("data_table"))
)
