# header -----------------------------------------------------------------------
# title: Server script for the css explorer application
# purpose: This script created the reactive elements for the application
# author: Sydney Bell
# ------------------------------------------------------------------------------

# defining the server function
server <- function(input, output, session){
  

# Search page information -------------------------------------------------
  # filtering the data based on the searched text
  filtered_data <- reactive({
    keyword <- tolower(trimws(input$search))
    filtered <- if (keyword == "") data else data[grepl(keyword, tolower(data$title_link)) |
                                                    grepl(keyword, tolower(data$description)), ]
    filtered
  })
  
  # output object for the search results table
  output$results_table <- renderReactable({
    results <- filtered_data()
    
    reactable(
      results,
      # hiding the header
      defaultColDef = colDef(headerClass = "hide"),
      columns = list(
        title_link = colDef(
          cell = function(value, index) {
            # Match original data to get ID (needed for modal)
            title <- results$title_link[index]
            desc <- results$description[index]
            id <- data$number[data$title_link == title]
            js <- sprintf(
              "Shiny.setInputValue('show_modal', %d, {priority: 'event'});",
              id
            )
            as.character(tags$div(
              style = "margin-bottom: 1em;",
              tags$a(
                href = "#",
                onclick = js,
                class = "search-link-title",
                paste0(title, " \U2794")  # Right arrow
              ),
              tags$div(class = "search-description", desc)
            ))
          },
          html = TRUE
        ),
        # hiding the other columns in the data frame
        number = colDef(show = FALSE),
        description = colDef(show = FALSE),
        css_code = colDef(show = FALSE),
        shiny_code = colDef(show = FALSE),
        output = colDef(show = FALSE)
      ),
      # specific styling for the reactable
      searchable = FALSE,
      pagination = TRUE,
      defaultPageSize = 5,
      bordered = FALSE,
      highlight = TRUE,
      striped = FALSE
    )
  })
  
  # observer to show the modal with the results on the search page
  observeEvent(input$show_modal, {
    id <- input$show_modal
    property <- data[data$number == id, ]
    
    showModal(modalDialog(
      # Title, property and description
      title = paste("Details for:", property$title_link),
      p(strong("Property:"), property$title_link),
      p(strong("Description:"), property$description),
      
      # Tabset to show example, Shiny code and CSS code
      tabsetPanel(
        tabPanel("Example", br(),
                 uiOutput(paste0(property$output))
        ),
        tabPanel("Shiny Code",
                 "Here is R code in the application",
                 verbatimTextOutput({paste0(property$shiny_code)})),
        tabPanel("CSS Code",
                 "Here is the CSS code showing the styling classes",
                 verbatimTextOutput({paste0(property$css_code)})
                 )),
      easyClose = TRUE,
      size = "l",
      footer = modalButton("Close")
    ))
  })
  

# Outputs for actionButton styling ----------------------------------------
  output$example_button <- renderUI({
    actionButton("button", "Example button", class = "new-button-style")
  })
  output$css_code_example_button <- renderText({
    "
/*Styling for: color of actionButtons*/
.new-button-style{
  background-color: black;
  color: white;
  font-size: 20px;
  border-radius: 10px;
  padding: 15px;
}
.new-button-style:focus,
.new-button-style:hover,
.new-button-style:active{
  background-color: #4A4A4A;
  color: white;
  font-size: 20px;
  border-radius: 10px;
  padding: 15px;
}
    "
  })
  
  output$shiny_code_example_button <- renderText({
    "
    # This is the code for the button
    actionButton(\"button1\", \"Example button\", class = \"new-button-style\")
    "
  })

# Outputs for tabset styling ----------------------------------------------

  output$example_tabs <- renderUI({
    div(class = "special-tabs",
    tabsetPanel( 
      tabPanel("1. Left Tab", "Content for 1. Left Tab"),
      tabPanel("2. Left Tab", "Content for 2. Left Tab"),
      tabPanel("2. Right Tab", "Content for 2. Right Tab"),
      tabPanel("1. Right Tab", "Content for 1. Right Tab")
    ))
  })
  output$css_code_example_tabs <- renderText({
    "
/* Styling for tab positioning */
.special-tabs .nav-tabs > li:nth-child(3),
.special-tabs .nav-tabs > li:nth-child(4) {
  float: right !important;
  margin-left:auto !important;
}

.special-tabs .nav-tabs > li:nth-child(4) > a:hover,
.special-tabs .nav-tabs > li:nth-child(4) > a:focus {
  background-image: linear-gradient(to bottom,
                    transparent 15%,
                    #ffffff 15%,
                    #ffffff 85%,
                    transparent 85%);
  background-position: 100% 0;
  background-size: 1px 100%;
  background-repeat: no-repeat;
}

.special-tabs .nav-tabs > li:nth-child(1),
.special-tabs .nav-tabs > li:nth-child(2) {
  float: left !important;
  margin-right:auto !important;
}

.special-tabs .nav-tabs > li:nth-child(2) > a:hover,
.special-tabs .nav-tabs > li:nth-child(2) > a:focus {
  background-image: linear-gradient(to bottom,
                    transparent 15%,
                    #ffffff 15%,
                    #ffffff 85%,
                    transparent 85%);
  background-position: 0 100%;
  background-size: 1px 100%;
  background-repeat: no-repeat;
}
    "
  })
  
  output$shiny_code_example_tabs <- renderText({
    "
    # This is the code for the tabs
    div(class = \"special-tabs\",
    tabsetPanel( 
      tabPanel(\"1. Left Tab\", \"Content for 1. Left Tab\"),
      tabPanel(\"2. Left Tab\", \"Content for 2. Left Tab\"),
      tabPanel(\"2. Right Tab\", \"Content for 2. Right Tab\"),
      tabPanel(\"1. Right Tab\", \"Content for 1. Right Tab\")
    ))
    "
  })
  

# Outputs for transition -------------------------------------------------
  output$example_transition <- renderUI({
      div(class = "transition-card",
          h2("Example card with transition"),
          h4("Hover over to see the red bottom border appear"))
  })
  
  output$css_code_example_transition <- renderText({
    "
/*Styling transition for cards*/
.transition-card{
  width: 25rem;
  height: 20rem;
  border: 0.0625 solid black;
  background: white;
  display: inline-block;
  -webkit-transition: border-bottom .4s;
  transition: border-bottom .4s;
}

.transition-card:hover, .transition-card:focus{
  border-bottom-color: darkred;
  border-bottom-style: solid;
  border-bottom-width: 0.25rem;
}
    "
  })
  
  output$shiny_code_example_transition <- renderText({
    "
    # This is the code for the card with transition
    div(class = \"transition-card\",
        h2(\"Example card with transition\"),
        h4(\"Hover over to see the red bottom border appear\"))
    "
  })
  

# Output for dropdown -----------------------------------------------------
  output$example_dropdown <- renderUI({
    div(class = "dropdown-style",
        pickerInput(
                inputId = "example_picker",
                label = "Select something from the dropdown",
                choices = c("Option 1", "Option 2", "Option 3")))
  })
  
  output$css_code_example_dropdown <- renderText({
    "
    /* Dropdown styling */
div .dropdown-style .bs-caret{
  font-size: 3rem;
  color: purple;
  background: lightgray;
  padding-right: 10px;
}
.dropdown-menu{
  padding-top: 0rem;
  padding-bottom: 0rem;
  background-color: lightgray;
}

div .dropdown-style .dropdown-item:hover,
div .dropdown-style .dropdown-item:focus{
  background-color: mediumpurple;
  color: black;
}
div .dropdown-style .dropdown-item.active.selected{
  background-color: purple;
  color: white;
}

div .dropdown-style .btn.dropdown-toggle.btn-default{
  background-color: lightgray;
}
    "
  })
  
  output$shiny_code_example_dropdown <- renderText({
    "div(class = \"dropdown-style\",
        pickerInput(
                inputId = \"example_picker\",
                label = \"Select something from the dropdown\",
                choices = c(\"Option 1\", \"Option 2\", \"Option 3\")))"
  })

# Output for font and spacing ---------------------------------------------
output$example_fonts <- renderUI({
  div(p("Red Text", class = "large-red-text"),
      p("Small black text", class = "small-black-text"))
})
  
  output$css_code_example_fonts <- renderText({
    "
/*Fonts and spacing*/
.large-red-text{
  font-size: 5rem;
  color: red;
  padding-left: 2rem;
}

.small-black-text{
  font-size: 1rem;
  color: black;
  padding-left: 5rem;
}
    "
  })
  
  output$shiny_code_example_fonts <- renderText({
    "div(p(\"Red Text\", class = \"large-red-text\"),
      p(\"Small black text\", class = \"small-black-text\"))"
  })

# Output for customizing bslib cards --------------------------------------
output$example_cards <- renderUI({
  layout_column_wrap(
    column(12, 
           div(class = "custom-card",
               navset_card_tab(
                 full_screen = TRUE,
                 title = "Example card with tabs",
                 nav_panel(
                   icon("chart-column"),
                   HTML("You can put some code in here to show a chart or anything else")
                 ),
                 nav_panel(
                   icon("table"),
                   h4("You can put some code in here to show a table or anything else")
                 )
               )))
  )
})
  
  output$css_code_example_cards <- renderText({
    "
/*bslib card styling*/
.bslib-grid>*{
  padding-bottom: 10px;
}

.custom-card{
  border: gray;
  box-shadow: 4px 4px 5px gray;
}

.custom-card .bslib-card .bslib-navs-card-title{
  font-size: 16px;
  padding-left: 20px;
  font-weight: 700;
  color: black;
  background-color: orange;
  border-bottom: 1px solid orange;
}

.custom-card .bslib-card .bslib-navs-card-title .nav{
  height: 50px;
}

.custom-card{
  .nav-tabs>li.active>a, 
  .nav-tabs>li.active>a:hover,
  .nav-tabs>li.active>a:hover{
    color: black;
    background-color: white;
    border: orange 1px solid;
    border-bottom: 4px solid gray!important;
    height: 50px;
  }
}

.custom-card{
  .nav-tabs>li>a{
    height: 50px;
  }
}

.custom-card{
  .nav-tabs>li>a:hover,
  .nav-tabs>li>a:focus{
  color: black;
  background-color: white;
  border: 1px solid orange;
  border-bottom: 4px solid grey!important;
}
}

.custom-card{
  .nav-tabs>li>a{
  border-radius: 0px;
  margin-right: 0px;
  border: 1px solid orange;
  color: black;
  border-bottom: 4px solid orange;
  max-width: 50px;
  font-size: 16px;
  background-color: white;
}
}

/* Styling for card content */
.bslib-card .html-fill-container>.html-fill-item{
  padding-top: 10px;
  padding-left: 5px;
  background-color: white;
}
.bslib-full-screen-enter{
  position: absolute;
  bottom: 1.5rem;
  right: 2.5rem;
  width: 20px;
  height: 20px;
  opacity: 1 !important;
  visibility: visible !important;
  transition: none !important;
  background-color: transparent;
  box-shadow: none !important;
  margin: 0.2rem 2rem !important;
}

.bslib-full-screen-enter svg{
  color: transparent;
  background-image: url(grey-expand.png);
  width: 20px!important;
  height: 20px !important;
  background-size: contain;
  background-repeat: no-repeat;
}

.bslib-full-screen-enter svg:hover {
  color: transparent;
  background-image: url(orange-expand.png);
  width: 20px!important; /* Set icon size */
  height: 20px!important;
  background-size: contain;
  background-repeat: no-repeat;
}

.bslib-full-screen-enter::after {
  content: \"\";
  color: gray;
  background-image: url(norange-expand.png);
  width: 20px; /* Set icon size */
  height: 20px;
  background-size: contain;
  background-repeat: no-repeat;
}

.bslib-full-screen-enter:hover::after, .bslib-full-screen-enter:focus::after{
  color: orange;
  content: \"\";
  background-image: url(orange-expand.png);
  width: 20px!important; /* Set icon size */
  height: 20px!important;
  background-size: contain;
  background-repeat: no-repeat;
}

/*styling the \"Close\" text on the bslib full screen card*/
.bslib-full-screen-exit{
  font-size: 1.8rem;
  font-weight: 700;
  margin-right: 10vw;
  padding-bottom: 10px;
}
/*styling the height and width of the expanded card*/
.bslib-card[data-full-screen = \"true\"]{
  max-height: 80vh !important;
  max-width: 80vw !important;
  margin-left: 10vw;
  border: 1px solid black;
}

.custom-card .bslib-card[data-full-screen = \"false\"] .html-fill-container>.html-fill-item{
  height: 300px;
}
    "
  })
  
  output$shiny_code_example_cards <- renderText({
    "
    layout_column_wrap(
    column(12, 
           div(class = \"custom-card\",
               navset_card_tab(
                 full_screen = TRUE,
                 title = \"Example card with tabs\",
                 nav_panel(
                   icon(\"chart-column\"),
                   HTML(\"You can put some code in here to show a chart or anything else\")
                 ),
                 nav_panel(
                   icon(\"table\"),
                   h4(\"You can put some code in here to show a table or anything else\")
                 )
               )))
  )
    "
  })
}