# plot_gadget.R

#' @title Interactively build a plot.
#' @description Launch an interactive HTML gadget that lets you
#' build a \pkg{ggplot2} plot from the given data.
#'
#' @param .data  a data-frame to visualize
#' @param popup  logical value to display the UI as a pop-up window.
#'               The default is FALSE, which will show the UI in
#'               the Viewer pane.
#'
#' @return the UI supports different return objects:
#' \itemize{
#'    \item Return Plot - returns a \pkg{ggplot2} plot object
#'    \item Return Code - returns a character vector of the plotting code. If
#'    you're using RStudio, this will insert the code at your cursor using the
#'    \pkg{rstudioapi} \code{\link[rstudioapi]{insertText}} function.
#' }
#'
#' @examples
#' \dontrun{
#' library(gogoplot)
#' plot_gadget(mtcars)
#' }
#'
#' @import ggplot2 shiny
#' @export
plot_gadget <- function(.data, popup = FALSE) {
  if (!inherits(.data, "data.frame"))
    stop(".data must be a data-frame.")
  data_name <- deparse(substitute(.data))

  ui <- miniUI::miniPage(
    miniUI::gadgetTitleBar("go-go plot!", right = NULL),
    miniUI::miniTabstripPanel(
      miniUI::miniTabPanel(
        'scatter',
        icon = shiny::icon('ellipsis-h'),
        miniUI::miniContentPanel(
          padding = 10,
          shiny::fillRow(
            flex = c(NA, 1),
            shiny::fillCol(
            flex = c(1, NA),
            width = 120,
            shiny::fillCol(
              flex = c(NA),
              shiny::radioButtons(
                'config',
                label = 'Configure...',
                choices = c('fields', 'color',
                            'facets', 'scales'),
                selected = 'fields'
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
                   "input.config == 'scales'",
                   shiny::helpText(shiny::strong('SCALES')),
                   shiny::helpText('functionality coming...')
                   ),
              shiny::conditionalPanel(
                "input.config == 'facets'",
                shiny::helpText(shiny::strong('FACET')),
                shiny::uiOutput("facet_row"),
                shiny::uiOutput("facet_col"),
                shiny::checkboxInput('facet_label', 'show field label',
                                     value = TRUE)
              )),
            shiny::fillCol(
              flex = c(NA),
              shiny::checkboxInput('auto_plot', 'auto-update',
                                   value = TRUE))),
            miniUI::miniContentPanel(
              padding = 0,
              shiny::plotOutput("plot_display", height = "100%")
              )
            )
          )
        ),
      miniUI::miniTabPanel(
        'histogram',
        icon = shiny::icon('bar-chart'),
        shiny::helpText('...under-construction...')
      ),
      miniUI::miniTabPanel(
        'data',
        icon = shiny::icon('database'),
        miniUI::miniContentPanel(padding = 5,
                                 shiny::dataTableOutput('data_table'))
      )
    ),
    miniUI::miniButtonBlock(
      shiny::actionButton('btn_update', 'Update Plot',
                          icon = shiny::icon('chart')),
      shiny::actionButton('btn_plot', 'Return Plot',
                          icon = shiny::icon('chart')),
      shiny::actionButton('btn_code', 'Return Code',
                          icon = shiny::icon('keyboard-o')),
      shiny::downloadButton('btn_save', 'Save Plot'),
      border = 'top'
    )
  )

  server <- function(input, output, session) {

    # dynamic UI input elements
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    output$xvar <- renderUI({
      selectInput("xvar", "x variable:",
                  choices = c('choose...', names(.data)), selected='choose...')
    })
    output$yvar <- renderUI({
      selectInput("yvar", "y variable:",
                  choices = c('choose...', names(.data)), selected='choose...')
    })
    output$color <- renderUI({
      selectInput("color", NULL,
                  choices = c('none', names(.data)), selected='choose...')
    })
    output$alpha <- renderUI({
      sliderInput("alpha", "alpha",
                  min = 0, max = 1, value = 1, step = 0.1)
    })
    output$facet_row <- renderUI({
      selectInput("facet_row", "facet rows:",
                  choices = c('none', names(.data)), selected='choose...')
    })
    output$facet_col <- renderUI({
      selectInput("facet_col", "facet cols:",
                  choices = c('none', names(.data)), selected='choose...')
    })

    # Render the plot
    output$plot_display <- shiny::renderPlot({
      if (input$auto_plot == TRUE) {
        plot <- plot()
      } else {
        input$btn_update
        plot <- isolate(plot())
      }
      plot
    })

    plot <- shiny::reactive({
      validate(
        need(input$xvar, 'Select an x variable.'),
        need(input$yvar, 'Select a y variable.'),
        need(input$xvar != 'choose...', 'Select an x variable.'),
        need(input$yvar != 'choose...', 'Select a y variable.')
      )
      # process input fields
      # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      if ('choose...' %in% c(input$xvar, input$yvar)) {
        return( ggplot() + geom_blank() )
      } else {
        xvar <- input$xvar
        yvar <- input$yvar
      }
      color <- ifelse(input$color == 'none', NA, input$color)
      if (!is.na(color)) {
        if (input$color_scale == 'discrete') {
          .data$`_COLOR` <- as.factor(.data[[color]])
        } else {
          .data$`_COLOR` <- .data[[color]]
        }
      }
      facet_row <- ifelse(input$facet_row == 'none', NA, input$facet_row)
      facet_col <- ifelse(input$facet_col == 'none', NA, input$facet_col)

      # build plot
      # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      g <- ggplot(.data, aes_string(x=xvar, y=yvar)) +
        theme_grey(15)
      if (is.na(color)) {
        g <- g + geom_point()
      } else {
        g <- g + geom_point(aes(color = `_COLOR`), alpha = input$alpha) +
          labs(color = color)
      }
      if (input$legend == FALSE) {
        g <- g + guides(color = 'none')
      }
      # coord_cartesian(xlim = rx$x_range, ylim = rx$y_range)
      if (all(is.na(facet_row), is.na(facet_col)) == FALSE) {
        if (input$facet_label == TRUE) {
          facet_labeller <- ggplot2::label_both
        } else {
          facet_labeller <- ggplot2::label_value
        }
        g <- g + facet_grid(paste(ifelse(is.na(facet_row), '.', facet_row), '~',
                                  ifelse(is.na(facet_col), '.', facet_col)),
                            labeller = facet_labeller)
      }
      g
    })

    # ---- plot_code ----
    plot_code <- shiny::reactive({
      code_vec <- NULL
      add_line <- function(code_vec, new_line) {
        if (is.null(code_vec)) {
          code_vec <- new_line
        } else {
          code_vec <- paste0(code_vec, " +\n  ", new_line)
        }
      }

      # process input fields
      # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      if ('choose...' %in% c(input$xvar, input$yvar)) {
        new_line <- sprintf("ggplot(%s) + geom_blank()", data_name)
        code_vec <- add_line(code_vec, new_line)
        return(code_vec)
      }

      # start building ggplot code
      new_line <- sprintf("ggplot(%s, aes(x = %s, y = %s))",
                          data_name, input$xvar, input$yvar)
      code_vec <- add_line(code_vec, new_line)
      code_vec <- add_line(code_vec, "theme_grey(15)")

      # ADD geom_point (with color code)
      if (input$color == 'none') {
        new_line <- "geom_point()"
        code_vec <- add_line(code_vec, new_line)
      } else {
        if (input$color_scale == 'discrete') {
          new_line <- sprintf("geom_point(aes(color = as.factor(%s)), alpha = %s)",
                              input$color, input$alpha)
        } else {
          new_line <- sprintf("geom_point(aes(color = %s), alpha = %s)",
                              input$color, input$alpha)
        }
        code_vec <- add_line(code_vec, new_line)
        code_vec <- add_line(code_vec, sprintf("labs(color = '%s')",
                                               input$color))
      }

      if (input$legend == FALSE) {
        code_vec <- add_line(code_vec, "guides(color = 'none')")
      }

      # add facet layer
      facet_row <- ifelse(input$facet_row == 'none', NA, input$facet_row)
      facet_col <- ifelse(input$facet_col == 'none', NA, input$facet_col)
      if (any(!is.na(facet_row), !is.na(facet_col))) {
        new_line <- sprintf("facet_grid(%s ~ %s, labeller = %s)",
                            ifelse(is.na(facet_row), '.', facet_row),
                            ifelse(is.na(facet_col), '.', facet_col),
                            ifelse(input$facet_label == TRUE,
                                   "label_both", "label_value"))
        code_vec <- add_line(code_vec, new_line)
      }
      code_vec
    })

    output$data_table <- shiny::renderDataTable({
      .data
    }, options = list(pageLength = 5))

    # indicate if plot is stale
    shiny::observeEvent(plot(), {
      if (input$auto_plot == T) {
        updateCheckboxInput(session, 'auto_plot', label = 'auto-update')
      } else {
        updateCheckboxInput(session, 'auto_plot', label = 'auto-update (*)')
      }
    })
    shiny::observeEvent(input$btn_update, {
      updateCheckboxInput(session, 'auto_plot', label = 'auto-update')
    })

    # buttons
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~

    # return Code
    shiny::observeEvent(input$btn_code, {
      code_vec <- plot_code()
      # return function call
      if(rstudioapi::isAvailable()){
        rstudioapi::insertText(text = code_vec)
        shiny::stopApp()
      } else{
        shiny::stopApp(code_vec)
      }
    })

    # return Plot object
    shiny::observeEvent(input$btn_plot, {
      shiny::stopApp(plot())
    })

    # download plot image
    output$btn_save <- downloadHandler(
      filename = function() {
        paste0(Sys.Date(), '-plot.png')
      },
      content = function(con) {
        ggsave(con, output$plot, device = 'png')
      }
    )
  }

  if (popup) {
    viewer = shiny::dialogViewer("GoGoPlot", width = 900, heigh = 800)
  } else {
    viewer = shiny::paneViewer()
  }
  shiny::runGadget(ui, server, viewer = viewer)
}


