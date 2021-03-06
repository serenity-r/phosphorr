% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/luminophor.R
\name{maximizeWidget}
\alias{maximizeWidget}
\alias{minimizeWidget}
\title{Maximize or minimize a widget in the dock}
\usage{
maximizeWidget(proxy, widgetId)

minimizeWidget(proxy, widgetId)
}
\arguments{
\item{proxy}{\link[=luminophorProxy]{Proxy LuminophoR object}}

\item{widgetId}{ID for luminophor widget}
}
\value{
\link[=luminophorProxy]{Proxy LuminophoR object}
}
\description{
Technically, minimizing a widget is more like un-maximizing a widget.  When
"minimized," the widget will return to its original position in the layout.
When a widget is maximized, it will take up the full size of the dock.
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
          actionButton('maximize', 'Maximize Plot', icon = icon('window-maximize')),
          actionButton('minimize', 'Minimize Plot', icon = icon('window-minimize'))
        ),
        mainPanel(
          luminophorOutput('lmo', height='90vh')
        )
      )
    ),
    server = function(input, output) {
      output$lmo <- renderLuminophor(
        luminophor() \%>\%
          addWidget("widget-slider",
                    title = "Slider",
                    ui = sliderInput("bins", "Number of bins:",
                                     min = 1, max = 50, value = 30)) \%>\%
          addWidget("widget-plot",
                    title = "Plot",
                    insertmode = "split-right",
                    refwidgetID = "widget-slider",
                    relsize = 0.75,
                    ui = plotOutput("distPlot"))
      )

      output$distPlot <- renderPlot({
        x <- faithful[, 2]
        bins <- seq(min(x), max(x), length.out = input$bins + 1)
        hist(x, breaks = bins, col = 'darkgray', border = 'white')
      })

      observeEvent(input$maximize, {
        luminophorProxy('lmo') \%>\%
          maximizeWidget('widget-plot')
      })

      observeEvent(input$minimize, {
        luminophorProxy('lmo') \%>\%
          minimizeWidget('widget-plot')
      })
    }
  )
}

}
