function(input, output, session) {
  renderSurvey()
  
  observeEvent(input$submit, {
    gs4_auth(
      cache = gargle::gargle_oauth_cache(),
      email = gargle::gargle_oauth_email()
    )
    
    # Retrieve existing datasheet
    sheet_url <-
      "https://docs.google.com/spreadsheets/d/1ITRoeX9TTGjkpKhOuqA2Ahr5xA6-K9gxPhcY6THQyKU/edit#gid=0"
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
    
    response <- bind_rows(response, timestamp)
    
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
    
    # Update summary stat data
    
    sumstat_sheet_url <-
      "https://docs.google.com/spreadsheets/d/11ZGUlqbg9lgjeX-Kehj1ppaCQqKJRwA1L8XlTF_lvis/edit#gid=0"
    previous_sum_stats <- read_sheet(sumstat_sheet_url)
    
    new_sum_stats <- data.frame(
      timestamp = timestamp$response,
      lat = input$lat,
      long = input$long
    )
    
    updated_sum_stats <- bind_rows(previous_sum_stats,
                                   new_sum_stats)
    
    write_sheet(updated_sum_stats, ss = sumstat_sheet_url, sheet = 'Sheet1')
    
    
  })
  
}
