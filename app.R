# -------------------------------
# 1. Load Libraries
# -------------------------------
library(shiny)

# -------------------------------
# 2. Load Dataset
# -------------------------------
toddler_data <- read.csv("Toddler Autism dataset July 2018.csv")

# -------------------------------
# 3. Preprocessing
# -------------------------------
toddler_data$Class.ASD.Traits. <- as.factor(toddler_data$Class.ASD.Traits.)

toddler_data$Sex <- as.factor(toddler_data$Sex)
toddler_data$Ethnicity <- as.factor(toddler_data$Ethnicity)
toddler_data$Jaundice <- as.factor(toddler_data$Jaundice)
toddler_data$Family_mem_with_ASD <- as.factor(toddler_data$Family_mem_with_ASD)
toddler_data$Who.completed.the.test <- as.factor(toddler_data$Who.completed.the.test)

# Remove leakage
toddler_data <- toddler_data[, !(names(toddler_data) %in% c("Case_No", "Qchat.10.Score"))]

# -------------------------------
# 4. Train-Test Split
# -------------------------------
set.seed(123)
sample_index <- sample(1:nrow(toddler_data), 0.7 * nrow(toddler_data))

train <- toddler_data[sample_index, ]

# -------------------------------
# 5. Models
# -------------------------------
train_basic <- train[, c("Age_Mons", "Sex", "Ethnicity",
                         "Jaundice", "Family_mem_with_ASD",
                         "Who.completed.the.test", "Class.ASD.Traits.")]

model_basic <- glm(Class.ASD.Traits. ~ ., data = train_basic, family = binomial)

model_advanced <- glm(Class.ASD.Traits. ~ ., data = train, family = binomial)

# -------------------------------
# 6. UI
# -------------------------------
ui <- fluidPage(
  titlePanel("ASD Risk Indicator (Non-Diagnostic)"),

  sidebarLayout(
    sidebarPanel(

      selectInput("model_type", "Choose Model:",
                  choices = c("Basic", "Advanced")),

      numericInput("age", "Age (Months):", 24, min = 12, max = 36),

      selectInput("sex", "Sex:", c("f", "m")),

      selectInput("jaundice", "Jaundice:", c("no", "yes")),

      selectInput("family", "Family History:", c("no", "yes")),

      selectInput("test", "Who Completed Test:",
                  choices = levels(train_basic$Who.completed.the.test)),

      # -------------------------------
      # A1–A10 with Explanation
      # -------------------------------
      conditionalPanel(
        condition = "input.model_type == 'Advanced'",

        h4("Behavioral Questions (A1–A10)"),

        p("Select 1 if the behavior is observed, 0 if not."),

        p("A1: Response to name"),
        selectInput("A1", "A1:", c(0,1)),

        p("A2: Eye contact"),
        selectInput("A2", "A2:", c(0,1)),

        p("A3: Social smiling"),
        selectInput("A3", "A3:", c(0,1)),

        p("A4: Sharing interest with others"),
        selectInput("A4", "A4:", c(0,1)),

        p("A5: Pointing to indicate interest"),
        selectInput("A5", "A5:", c(0,1)),

        p("A6: Pretend play"),
        selectInput("A6", "A6:", c(0,1)),

        p("A7: Following gaze"),
        selectInput("A7", "A7:", c(0,1)),

        p("A8: Understanding gestures"),
        selectInput("A8", "A8:", c(0,1)),

        p("A9: Repetitive behavior"),
        selectInput("A9", "A9:", c(0,1)),

        p("A10: Attention switching"),
        selectInput("A10", "A10:", c(0,1))
      ),

      actionButton("predict", "Predict Risk")
    ),

    mainPanel(
      h3("Prediction Result"),
      textOutput("result"),
      textOutput("prob"),

      br(),
      h4("Disclaimer"),
      p("This tool estimates behavioral risk indicators only. It is NOT a diagnosis.")
    )
  )
)

# -------------------------------
# 7. Server
# -------------------------------
server <- function(input, output) {

  observeEvent(input$predict, {

    new_data_basic <- data.frame(
      Age_Mons = input$age,
      Sex = factor(input$sex, levels = levels(train_basic$Sex)),
      Ethnicity = factor("asian", levels = levels(train_basic$Ethnicity)),
      Jaundice = factor(input$jaundice, levels = levels(train_basic$Jaundice)),
      Family_mem_with_ASD = factor(input$family, levels = levels(train_basic$Family_mem_with_ASD)),
      Who.completed.the.test = factor(input$test,
                                      levels = levels(train_basic$Who.completed.the.test))
    )

    if(input$model_type == "Advanced"){

      new_data <- new_data_basic

      for(i in 1:10){
        new_data[[paste0("A", i)]] <- as.numeric(input[[paste0("A", i)]])
      }

      prob <- predict(model_advanced, new_data, type = "response")

    } else {

      prob <- predict(model_basic, new_data_basic, type = "response")
    }

    result <- ifelse(prob > 0.7, "Higher Risk", "Lower Risk")

    output$result <- renderText({
      paste("Risk Category:", result)
    })

    output$prob <- renderText({
      paste("Risk Probability:", round(prob, 2))
    })
  })
}

# -------------------------------
# 8. Run App
# -------------------------------
shinyApp(ui = ui, server = server)
