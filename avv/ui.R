header<-dashboardHeader(title="OM 28/06/2018 Esche/Bocconi e Avvelenamenti")

body<-dashboardBody(
  fluidRow(
    column(width=5,
           box(width=NULL, 
               title="Seleziona l'anno e la specie/esca-boccone", solidHeader = TRUE,
               status="info",
               sliderInput("anno", "Anno", min=2002, max=2018, value=2018),
               
               br(),
               selectInput("specie", "Specie/Esca Boccone",
                           c(unique(as.character(avv$specie))), selected = "CANE")
               ),
               box(width=NULL,
                   
                   title = "Casistica per anno",
                   status = "danger", solidHeader = TRUE, collapsible = TRUE,collapsed = TRUE,
               plotOutput("p")
               )
           
    ),
    column(width = 7,
           box(width = NULL, solidHeader = TRUE,
               leafletOutput("map", height=400)),
               
        
           box(width=NULL,solidHeader = TRUE,title="Casistica per comune e sostanza identificata", status="info",
           dataTableOutput("tabella")
           )
    )

))

dashboardPage(
  header,
  dashboardSidebar(disable = TRUE),
  body
)