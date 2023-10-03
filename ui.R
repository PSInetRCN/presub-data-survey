
fluidPage(
  theme = bs_theme(version = 3),
  surveyOutput(df = df,
               survey_title = "Pre-submission survey",
               survey_description = h4(HTML("Thank you for your interest in contributing to PSInet. Please complete the following form <b>for a single dataset</b>. <br> <br> <i>Note that all required fields must be completed to activate the 'Submit' button, including each row of the meteorological matrix. </i>")),
               theme = "#358DBD")
)
