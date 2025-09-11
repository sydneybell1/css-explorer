# header -----------------------------------------------------------------------
# title: Global script for the css explorer application
# purpose: This script loads in the needed packages and data for the application
# author: Sydney Bell
# ------------------------------------------------------------------------------

# loading in packages -----------------------------------------------------
library(shiny)
library(reactable)
library(shinyWidgets)
library(bslib)

# creating the data for the search table ---------------------------------------
data <- data.frame(
  # row number
  number = c(1, 2, 3, 4, 5, 6),
  # title for the CSS property
  title_link = c("Customizing tab alignment for tabsetPanel", 
                 "Custom styling for actionButton appearance and hover", 
                 "Creating border transition on interaction", 
                 "Adding styling to dropdowns", 
                 "Adjusting font size and spacing for text elements",
                 "Customizing bslib cards"),
  # description for the CSS property
  description = c("This CSS targets a specific tabsetPanel() (with class 'special-tabs') to align the first two tabs to the left and the last two tabs to the right using float and auto margins. It also adds a subtle hover effect with a vertical gradient underline to the second and fourth tabs for visual emphasis.",
                  "This CSS defines a custom style (new-button-style) for an actionButton. The class changes the color of the background, the color of the text, creates rounded corners and increases the font size and padding. The button changes appearance slightly on hover, focus, and active states.",
                  "This CSS property uses -webkit-transition to animate changes to the bottom border of an element, creating a smooth visual effect when a user interacts with it (e.g., hover or focus). It enhances user experience by providing a subtle yet noticeable transition.",
                  "This styling modifies a dropdown menu by customizing its background color, hover states, and the Bootstrap caret (.bs-caret) color. It provides a cohesive and visually appealing dropdown experience that aligns with your design theme.",
                  "These CSS classes define custom text styles with specific font sizes, colors, and left padding. .large-red-text creates bold, attention-grabbing red text, while .small-black-text offers a more subtle, spaced-out black text style—ideal for visual hierarchy in layout design.",
                  "Adjust the styling of cards by changing specific elements and colors to match the theme of your application."),
  # output ID for the example in the modal
  output = c("example_tabs", 
             "example_button", 
             "example_transition", 
             "example_dropdown", 
             "example_fonts", 
             "example_cards"),
  # output ID for the CSS code example in the modal
  css_code = c("css_code_example_tabs",
               "css_code_example_button",
               "css_code_example_transition",
               "css_code_example_dropdown",
               "css_code_example_fonts",
               "css_code_example_cards"),
  # output ID for the shiny code example in the modal
  shiny_code = c("shiny_code_example_tabs",
                 "shiny_code_example_button",
                 "shiny_code_example_transition",
                 "shiny_code_example_dropdown",
                 "shiny_code_example_fonts",
                 "shiny_code_example_cards")
  )