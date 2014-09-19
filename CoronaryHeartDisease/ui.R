shinyUI(fluidPage(
	titlePanel("Risk of Developing Coronary Heart Disease Over 10 Years"),

	fluidRow(
		
		column(3, ""),
		
		column(9, p(em("Documentation File:",a("CoronaryHeartDisease",href="index.html"))))),
	
	fluidRow(
		# enter age using slider
		column(3, wellPanel(	
			 sliderInput("age", label = h4("Select Your Age"),
			 		min = 30, max = 80, value = 55))),

		# enter gender using radio buttons
		column(3, wellPanel(
			 radioButtons("gender", label = h4("Specify Your Gender"),
			 		 choices = list("Male" = 1, "Female" = 2),
			 		 selected = 1))),
		
		column(3, wellPanel(
			 radioButtons("smoker", label = h4("Do You Smoke?"),
			 		 choices = list("Yes/smoker" = 1, "No/non-smoker" = 0),
			 		 selected = 1))),
		
		column(3, wellPanel(
			 radioButtons("diabetic", label = h4("Do You Have Diabetes?"),
			 		 choices = list("Yes/diabetic" = 1, "No/non-diabetic" = 0),
			 		 selected = 0))) 
	),
	# end of fluidrow 1
	
	fluidRow(column(12,hr())),
	
	fluidRow(
		
		column(3,
			 selectInput("tc", label = h4("Total Cholesterol (mg/dL)"), 
			 		choices = list("Less than 160" = 3,
			 				   "160 to 199" = 4,
			 				   "200 to 239" = 5,
			 				   "240 to 279" = 6,
			 				   "280 or more" = 7), 
			 		selected = 6)),
		
		column(3,
			 selectInput("ldlc", label = h4("LDL (Bad) Cholesterol (mg/dL)"), 
			 		choices = list("Less than 100" = 3,
			 				   "100 to 129" = 4,
			 				   "130 to 159" = 5,
			 				   "160 to 189" = 6,
			 				   "190 or more" = 7), 
			 		selected = 6)),
		
		column(3,
			 selectInput("hdlc", label = h4("HDL (Good) Cholesterol (mg/dL)"), 
			 		choices = list("Less than 35" = 8,
			 				   "35 to 44" = 9,
			 				   "45 to 49" = 10,
			 				   "50 to 59" = 11,
			 				   "60 or more" = 12), 
			 		selected = 9)),
		
		column(3,
			 selectInput("bp", label = h4("BP Systolic/Diastolic (mm Hg"), 
			 		choices = list("Less than 120 / Less than 80" = 13,
			 				   "120 to 129 / 80 to 84" = 14,
			 				   "130 to 139 / 85 to 89" = 15,
			 				   "140 to 159 / 90 to 99" = 16,
			 				   "160 or more / 100 or more" = 17), 
			 		selected = 16))
	), 
	# end of fluidrow 2
	
	fluidRow(column(12,hr())),
	
	fluidRow(
		
		column(1, ""),
		
		column(3,
			# Show a table summarizing the values entered
			tableOutput("values")),
		
		column(8, 
			 plotOutput("plot1"))

	)
	
	
	# end of fluidrow 3
))
