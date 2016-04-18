
cleanInputData <- function(inString)
{
  train_data <- inString
  train_data <- gsub(pattern="[^A-Za-z ']+", x=train_data, replacement = ' ')
  train_data <- tolower(train_data)  ## Conversion to lower case letters
  train_data <- trimws(train_data)
  
  return(train_data)
}

