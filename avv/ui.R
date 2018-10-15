header<-dashboardHeader(title="OM 28/06/2018 Esche/Bocconi e Avvelenamenti")

body<-dashboardBody(
  fluidRow(
    column(width = 7,
           box(width = NULL, solidHeader = TRUE,
               leafletOutput("map", height=600)),
               
        
           box(width=NULL,solidHeader = TRUE,
           dataTableOutput("tabella")
           )
    ),
    column(width=5,
            box(width=NULL, 
              sliderInput("anno", "Anno", min=2002, max=2018, value=2018),
               
              br(),
               selectInput("specie", "Specie/Esca Boccone",
                           c(unique(as.character(avv$specie))), selected = "CANE"),
               hr(),
               br(),
               plotOutput("p")
    )
  )
))

dashboardPage(
  header,
  dashboardSidebar(disable = TRUE),
  body
)