# Tarefa 06 - obrigar o bot a clicar em "busca avancada"

# bibliotecas 

library(RSelenium)
library(wdman)
library(netstat)
library(tidyverse)
library(rvest)

# código base da aula

wpage <- "https://emec.mec.gov.br"
maxpages <- 13

remote_driver <- rsDriver(
  browser = "firefox",
  port = 4567L,
  verbose = FALSE,
  chromever = NULL # necessário
)

remDr <- remote_driver$client

remDr$navigate(wpage)
Sys.sleep(15)

hh <- "https://emec.mec.gov.br/emec/nova"
remDr$navigate(hh)
Sys.sleep(15)

# código da tarefa

con_avancada <- remDr$findElement(using = "xpath", 
                                  value = "/html/body/div[3]/div/div[3]/ul/li[1]/a")
con_avancada$clickElement()