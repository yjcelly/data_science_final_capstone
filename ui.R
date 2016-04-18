shinyUI(pageWithSidebar(
  

sidebarPanel(
  h3('Usage Help:'),
  h5("Input:"),
  p('typing the words in the input box'),
  h5("Output: "),
  p('the output box will show the top-5 probably next words')
),

headerPanel("Predict Next Word"),
mainPanel(
  textInput(inputId="inputTxt", label = "Input  words"),
  p('Output predict words'),
  textOutput('outputTxt')
)
))