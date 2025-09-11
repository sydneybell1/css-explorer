# header -----------------------------------------------------------------------
# title: UI script for the css explorer application
# purpose: This script creates all the content for the interface of the 
# application.
# author: Sydney Bell
# ------------------------------------------------------------------------------

# defining the UI
ui <- navbarPage(
  # title and window information
  title = div("CSS Explorer", class = "navbar-brand"),
  id = "main_nav",
  windowTitle = "CSS Explorer",
  # loading in the styles sheet
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "styles.css")
  ),
  # creating the search page
  tabPanel("Search",
           # page heading
           h1("App for Exploring CSS Properties and Examples"),
           h4("Navigate through the app and find ways to level up your {shiny} application."),
           br(),
           # search input to filter results
           textInput("search", h3("Search for a CSS property:"), ""), br(),
           
           # search results table
           reactableOutput("results_table"),
           
           # JavaScript for modal trigger
           tags$script(HTML("
           Shiny.addCustomMessageHandler('openModal', function(message) {
           Shiny.setInputValue('show_modal', message, {priority: 'event'});
           });
           "))
           ),
  # creating the about page
  tabPanel("About", 
           # page heading
           h1("About the CSS Explorer"),
           h4("This application was built as a tool to explore different applications of CSS and show users 
              how to implement them in shiny. This is not meant to be an exhaustive list of properties just
              show users how to get started with customizing their app with CSS."))
)