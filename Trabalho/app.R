library(shiny)
library(tidyverse)
library(ggplot2)
library(geobr)
library(rcartocolor)

# Carregar dados inicialmente
df_covid_sp <- read.csv(file.choose(), sep = ";")
df_covid_sp$datahora <- as.Date(df_covid_sp$datahora)

  ui <- fluidPage(
    titlePanel("Análise espacial de COVID-19 por Município e Ano"),
    
    navbarPage("",
      tabPanel("Mapa 1",
        sidebarLayout(
          sidebarPanel(
            radioButtons("anos", "Selecione os anos:",
                               choices = c("Acumulado", unique(data.table::year(df_covid_sp$datahora))),
                               selected = c("Acumulado", unique(data.table::year(df_covid_sp$datahora)))[1])
          ),
          
          mainPanel(
            plotOutput("mapa")
          ))
      ),
      tabPanel("Mapa 2",
               sidebarLayout(
                 sidebarPanel(
                   radioButtons("anos2", "Selecione os anos:",
                                choices = unique(data.table::year(df_covid_sp$datahora)),
                                selected = unique(data.table::year(df_covid_sp$datahora)[1])
                   )
                 ),
                 
                 mainPanel(
                   plotOutput("mapa2")
                 )
               )
      ),
      tabPanel("Mapa 3",
               sidebarLayout(
                 sidebarPanel(
                   radioButtons("anos3", "Selecione os anos:",
                                choices = unique(data.table::year(df_covid_sp$datahora)),
                                selected = unique(data.table::year(df_covid_sp$datahora)[1])
                   )
                 ),
                 
                 mainPanel(
                   plotOutput("mapa3")
                 )
               )
      )
    )
  )

server <- function(input, output) {
  
  # df_covid_sp <- read.csv("teste/dados/dados_covid_sp.csv", sep = ";")
  output$mapa <- renderPlot({
    anos_selecionados <- if (input$anos == "Acumulado") {
      unique(data.table::year(df_covid_sp$datahora))
    } else {
      as.numeric(input$anos)
    }
    
    df_filtrado <- subset(df_covid_sp, nome_munic != "Ignorado") %>%
      mutate(ano = as.numeric(format(datahora, "%Y"))) %>%
      filter(ano %in% anos_selecionados) %>%
      group_by(nome_munic, codigo_ibge, ano) %>%
      summarise(total_casos_novos = sum(casos_novos)) %>%
      left_join(geobr::read_municipality(code_muni = 35, year = 2010), ., by = c("code_muni" = "codigo_ibge"))
    
    ggplot() +
      geom_sf(data = df_filtrado, aes(fill = total_casos_novos), color = NA, size = .15) +
      scale_fill_gradientn(colours = rcartocolor::carto_pal(6, "SunsetDark"),
                           name = "Total", labels = scales::label_number(big.mark = ".", accuracy = 1)) +
      theme(plot.title = element_text(hjust = 0.5),
            axis.text = element_blank(),
            axis.ticks = element_blank(),
            panel.background = element_rect(fill = "white"))
  })

  output$mapa2 <- renderPlot({
    anos_selecionados <- as.numeric(input$anos2)
    
    df_filtrado_tx <- subset(df_covid_sp, nome_munic != "Ignorado") %>%
      mutate(ano = as.numeric(format(datahora, "%Y"))) %>%
      filter(ano %in% anos_selecionados) %>%
      group_by(nome_munic, codigo_ibge, ano) %>%
      summarise(total_casos_novos = sum(casos_novos/pop)) %>%
      left_join(geobr::read_municipality(code_muni = 35, year = 2010), ., by = c("code_muni" = "codigo_ibge"))
    
    ggplot() +
      geom_sf(data = df_filtrado_tx, aes(fill = total_casos_novos), color = NA, size = .15) +
      scale_fill_gradientn(colours = rcartocolor::carto_pal(6, "SunsetDark"), limits = c(0.00, 0.40),
                           name = "Total", labels = scales::label_number(big.mark = ".")) +
      theme(plot.title = element_text(hjust = 0.5),
            axis.text = element_blank(),
            axis.ticks = element_blank(),
            panel.background = element_rect(fill = "white"))
    
  })
  
  
  output$mapa3 <- renderPlot({
    anos_selecionados <- as.numeric(input$anos3)
    
    df_filtrado_cv <- subset(df_covid_sp, nome_munic != "Ignorado") %>%
      mutate(ano = as.numeric(format(datahora, "%Y"))) %>%
      filter(ano %in% anos_selecionados) %>%
      group_by(nome_munic, codigo_ibge, ano) %>%
      summarise(total_casos_novos = sd(casos_novos/pop)/mean(casos_novos/pop)) %>%
      left_join(geobr::read_municipality(code_muni = 35, year = 2010), ., by = c("code_muni" = "codigo_ibge"))
    
    ggplot() +
      geom_sf(data = df_filtrado_cv, aes(fill = total_casos_novos), color = NA, size = .15) +
      scale_fill_gradientn(colours = rcartocolor::carto_pal(6, "SunsetDark"), limits = c(0.00, 20.00),
                           name = "Total", labels = scales::label_number(big.mark = ".")) +
      theme(plot.title = element_text(hjust = 0.5),
            axis.text = element_blank(),
            axis.ticks = element_blank(),
            panel.background = element_rect(fill = "white"))
  })
  
}


shinyApp(ui, server)
