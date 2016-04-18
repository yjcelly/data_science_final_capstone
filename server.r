library(shiny)

source("predict.R")
source("clean_data.R")

PredictNextWord <- function(inString)
{
  tmpCleanData <- inString
  tmpCleanData <- cleanInputData(inString)
  return(getNextWordPrediction(tmpCleanData) )
  #return(tmpCleanData)
}



shinyServer(
function(input, output,session) {

  
  strNextWord <- reactive({
    inputWord <- input$inputTxt
    retWords <- PredictNextWord(inputWord)
    segStr <- unlist( strsplit(retWords," ") )
    return(paste0(segStr,collapse=",  "))
  }) 
  output$outputTxt <- renderText({
    strNextWord()
  })
}
)