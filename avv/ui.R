header<-dashboardHeader(title="OM 28/06/2018 Esche/Bocconi e Avvelenamenti")

body<-dashboardBody(
  fluidRow(
    column(width = 9,
           box(width = NULL, solidHeader = TRUE,
               leafletOutput("map", height=800)
           # ),
           # box(width=NULL,
           #     dataTableOutput("boroughTable")
           # )
    )),
    column(width=3,
           box(width=NULL, 
               selectInput("anno", "Anno",
                           c(unique(as.character(avv$anno))), selected = 2018),
               br(),
               selectInput("specie", "Specie/Esca Boccone",
                           c(unique(as.character(avv$specie))), selected = "CANE")
           #     uiOutput("yearSelect"),
           #     radioButtons("meas", "Measure",c("Mean"="Mean", "Median"="Median")),
           #     checkboxInput("city", "Include City of London?",TRUE)
           #     
           # )
    )
  )
))

dashboardPage(
  header,
  dashboardSidebar(disable = TRUE),
  body
)