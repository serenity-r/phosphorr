% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/luminophor.R
\name{removeWidgets}
\alias{removeWidgets}
\title{Remove widgets in the dock}
\usage{
removeWidgets(proxy, widgetIDs = NULL, .all = FALSE)
}
\arguments{
\item{proxy}{\link[=luminophorProxy]{Proxy LuminophoR object}}

\item{widgetIDs}{IDs for luminophor widget}

\item{.all}{Remove all widgets?  This will override any ids specified in \code{widgetIDs}}
}
\value{
\link[=luminophorProxy]{Proxy LuminophoR object}
}
\description{
Remove widgets in the dock
}
\examples{
if (interactive()) {
  library(shiny)
  library(luminophor)
  shinyApp(
    ui = fluidPage(
      titlePanel("Old Faithful Geyser Data"),
      sidebarLayout(
        sidebarPanel(
          actionButton('rerender', 'Rerender', icon = icon('redo')),
          actionButton('remove_slider', 'Remove Slider', icon = icon('times')),
          actionButton('remove_all', 'Remove All', icon = icon('times'))
        ),
        mainPanel(
          luminophorOutput('lmo', height='90vh')
        )
      )
    ),
    server = function(input, output) {
      output$lmo <- renderLuminophor({
        input$rerender
        initval <- isolate({if (!is.null(input$bins)) input$bins else 30})

        luminophor() \%>\%
          addWidget("widget-slider",
                    title = "Slider",
                    ui = sliderInput("bins", "Number of bins:",
                                     min = 1, max = 50, value = initval)) \%>\%
          addWidget("widget-plot",
                    title = "Plot",
                    insertmode = "split-right",
                    refwidgetID = "widget-slider",
                    relsize = 0.75,
                    ui = plotOutput("distPlot"))
      })

      output$distPlot <- renderPlot({
        x <- faithful[, 2]
        bins <- seq(min(x), max(x), length.out = input$bins + 1)
        hist(x, breaks = bins, col = 'darkgray', border = 'white')
      })

      observeEvent(input$remove_slider, {
        luminophorProxy('lmo') \%>\%
          removeWidgets('widget-slider')
      })

      observeEvent(input$remove_all, {
        luminophorProxy('lmo') \%>\%
          removeWidgets(.all = TRUE)
      })
    }
  )
}

}
