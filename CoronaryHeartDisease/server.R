library(shiny)
library(ggplot2)
# 
TC_Model <- data.frame(cbind(
	c(0.04826, 0.33766),
	c(0, -0.00268),
	c(-0.65945, -0.26138),
	c(0,0),
	c(0.17692, 0.20771),
	c(0.50539, 0.24385),
	c(0.65713, 0.53513),
	c(0.49744, 0.84312),
	c(0.24310, 0.37796),
	c(0, 0.19785),
	c(-0.05107, 0),
	c(-0.48660, -0.42951),
	c(-0.00226, -0.53363),
	c(0, 0),
	c(0.28320, -0.06773),
	c(0.52168, 0.26288),
	c(0.61859, 0.46573),
	c(0.42839, 0.569626),
	c(0.52337, 0.29246),
	c(0.90015, 0.96246),
	c(3.0975, 9.92545)))


colnames(TC_Model) <- c("Age","Age2","TC1","TC2","TC3","TC4","TC5","HDLC1","HDLC2",
				"HDLC3","HDLC4","HDLC5","BP1","BP2","BP3","BP4","BP5",
				"Diabetes","Smoker","S","G")

LDLC_Model <- data.frame(cbind(
	c(0.04808, 0.33994),
	c(0, -0.0027),
	c(-0.69281, -0.42616),
	c(0,0),
	c(0.00389, 0.01366),
	c(0.26755, 0.26948),
	c(0.56705, 0.33251),
	c(0.48598, 0.88121),
	c(0.21643, 0.36312),
	c(0, 0.19247),
	c(-0.0471, 0),
	c(-0.34190, -0.35404),
	c(-0.02642, -0.51204),
	c(0, 0),
	c(0.3101, -0.03484),
	c(0.55714, 0.28533),
	c(0.65107, 0.50403),
	c(0.42146, 0.61313),
	c(0.54377, 0.29737),
	c(0.90017, 0.9628),
	c(3.00069, 9.914136)))
	
	colnames(LDLC_Model) <- c("Age","Age2","TC1","TC2","TC3","TC4","TC5","HDLC1","HDLC2",
					"HDLC3","HDLC4","HDLC5","BP1","BP2","BP3","BP4","BP5",
					"Diabetes","Smoker","S","G")
	
shinyServer(function(input, output) {
	
	# Reactive expression to compose a data frame containing all of
	# the values entered
	chdValues <- reactive({
		
		HDL_index = as.integer(input$gender) + 9
		
		# Calculated risk for Total Cholesterol Model
		TC_L = as.numeric(input$age*TC_Model[input$gender,1] 
					  + input$age^2*TC_Model[input$gender,2]
					  + as.numeric(input$smoker) * TC_Model[input$gender,19]
					  + as.numeric(input$diabetic) * TC_Model[input$gender,18]
					  + TC_Model[input$gender,as.integer(input$tc)]
					  + TC_Model[input$gender,as.integer(input$hdlc)]
					  + TC_Model[input$gender,as.integer(input$bp)])
		
		TC_S = TC_Model[input$gender,20]
		TC_G = TC_Model[input$gender,21]
		TC_A = TC_L - TC_G 
		TC_B = exp(TC_A)
		TC_P = 100*(1-TC_S^TC_B)

		# Calculated risk for Total Cholesterol Reference
		TCbase_L = as.numeric(input$age*TC_Model[input$gender,1] 
					    + input$age^2*TC_Model[input$gender,2]
					    + TC_Model[input$gender,4]
					    + TC_Model[input$gender, HDL_index]
					    + TC_Model[input$gender,14])
		
		TCbase_S = TC_Model[input$gender,20]
		TCbase_G = TC_Model[input$gender,21]
		TCbase_A = TCbase_L - TCbase_G 
		TCbase_B = exp(TCbase_A)
		TCbase_P = 100*(1-TCbase_S^TCbase_B)
		
		# Calculated risk for LDL Cholesterol Model		
		LDL_L = as.numeric(input$age*LDLC_Model[input$gender,1] 
			     + input$age^2*LDLC_Model[input$gender,2]
			     + as.numeric(input$smoker) * LDLC_Model[input$gender,19]
			     + as.numeric(input$diabetic) * LDLC_Model[input$gender,18]
			     + LDLC_Model[input$gender,as.integer(input$ldlc)]
			     + LDLC_Model[input$gender,as.integer(input$hdlc)]
			     + LDLC_Model[input$gender,as.integer(input$bp)])
					
		LDL_S = LDLC_Model[input$gender,20]
		LDL_G = LDLC_Model[input$gender,21]
		LDL_A = LDL_L - LDL_G
		LDL_B = exp(LDL_A)
		LDL_P = 100*(1-LDL_S^LDL_B)
		
		# Calculated risk for Total Cholesterol Reference
		LDLbase_L = as.numeric(input$age*LDLC_Model[input$gender,1] 
					+ input$age^2*LDLC_Model[input$gender,2]
					+ LDLC_Model[input$gender,4]
					+ LDLC_Model[input$gender, HDL_index]
					+ LDLC_Model[input$gender,14])
		
		LDLbase_S = LDLC_Model[input$gender,20]
		LDLbase_G = LDLC_Model[input$gender,21]
		LDLbase_A = LDLbase_L - LDLbase_G 
		LDLbase_B = exp(LDLbase_A)
		LDLbase_P = 100*(1-LDLbase_S^LDLbase_B)
		
		data.frame(
			Model = c("Total Cholesterol Reference",
				 "Total Cholesterol Model",
				 "LDL Cholesterol Reference",
				 "LDL Cholesterol Model"),
			Percent = c(TCbase_P, TC_P, LDLbase_P, LDL_P))
		
	})
	
	# Show the values using an HTML table
	output$values <- renderTable({
		chdValues()
	})

	output$plot1 <- renderPlot({

		ggplot(chdValues(), aes(y=Percent, x=Model, fill=Model)) + 
			geom_bar(stat="identity", width=0.7, color="grey") + 
			scale_fill_manual(values=c("#99CC66", "#778866","#66CCFF", "#336699")) + 
			ylab("10-Year Percent Risk of Developing CHD") + 
			geom_text(aes(label=round(Percent,2)), hjust=-0.2, size=4) + 
			xlab("") + ylim(0,100) +
			ggtitle("Comparative Risk by Model versus Reference Risk") + 
			coord_flip()
	})
})

# Equation 1
# L <- age x Age + age^2 * Age2 + TCn + HDLCn + BPn + Diabetes + Smoker

# Equation 2
# A <- G - L 

# Equation 3
# B = exp(A)

#Equation 4
# P = 1- S^B