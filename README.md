ALERTapp
========

A Shiny web application that implements the ALERT algorithm for detecting the onset of influenza season.

To run this app locally, follow these steps:
1. open R
2. Run this code:
install.packages("shiny")
install.packages("devtools")
require("shiny")
require("devtools")
install_github("ALERT", "nickreich")
require("ALERT")
runApp("ALERT")