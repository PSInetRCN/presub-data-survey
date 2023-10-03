function(input, output, session) {
  renderSurvey()
  
  observeEvent(input$submit, {
    gs4_auth(
      cache = gargle::gargle_oauth_cache(),
      email = gargle::gargle_oauth_email()
    )
    
    # Retrieve existing datasheet
    sheet_url <- "https://docs.google.com/spreadsheets/d/14wDlPzgNjRf7eKpNRgfgn955Mk2nFsGXJWI51Pan2Z4/edit#gid=0"
    previous <- read_sheet(sheet_url)
    
    # Obtain and and append submitted results
    response <- getSurveyData(custom_id = input$email,
                              include_dependencies = FALSE)
    
    
    timestamp <- data.frame(
      subject_id = input$email,
      question_id = "timestamp",
      question_type = "time",
      response = as.character(Sys.time())
    )
    
    met_data_type <- data.frame(
      subject_id = input$email,
      question_id = "met_data_type",
      question_type = "met_data_type",
      response = "checkbox"
    )
    response <- bind_rows(response, timestamp)
    response <- bind_rows(response, met_data_type)
    
    updated <- bind_rows(previous, response)
    
    # Write back to Google sheet
    write_sheet(updated, ss = sheet_url, sheet = 'Sheet1')
    
    # Show submission message
    showModal(
      modalDialog(
        title = "Thank you. We'll be in touch shortly with next steps",
        "Please reach out to Jessica Guo (jessicaguo@arizona.edu) and Michael Benson (micbenso@iu.edu) with any questions. "
      )
    )
    
  })
  
}
