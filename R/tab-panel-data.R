dataTabPanel <- miniUI::miniTabPanel(
  "data",
  icon = shiny::icon("database"),
  miniUI::miniContentPanel(
    padding = 10,
    shiny::htmlOutput("data_table_header"),
    shiny::dataTableOutput("data_table"))
)
