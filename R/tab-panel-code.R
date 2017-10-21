codeTabPanel <- miniUI::miniTabPanel(
  "code",
  icon = shiny::icon("code"),
  miniUI::miniContentPanel(
    padding = 15,
    shiny::htmlOutput("render_code_html")
    )
  )

