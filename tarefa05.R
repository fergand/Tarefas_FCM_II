library(tidyverse)
library(read.dbc)
library(lubridate)

# Lendo o arquivo --------------------------------------------------
linhas <- readLines("Regex/RACA_COR.CNV", encoding = "UTF-8") %>% 
  iconv(from = "latin1", to = "UTF-8") 
linhas <- linhas[-1] %>% trimws("both") %>% 
  gsub(" +", " ", .)

# Extraindo a id --------------------------------------------------
id <- linhas %>% str_extract("\\d+")

# Extraindo a Etnia (categoria) -----------------------------------
etnia_1 <- linhas[1:9] %>% 
  gsub("(^\\d+\\s)", "", .) %>% 
  gsub("\\s+[0-9A-Z,\\s]+\\s*$", "", .)

etnia_2 <- linhas[10] %>% 
  gsub("(^\\d+\\s)", "", .) %>% 
  str_extract(".*\\)")

etnia <- c(etnia_1, etnia_2)

# Extraindo o valor da categaoria ---------------------------------

codigo <- linhas %>% 
  gsub("(^\\d+\\s)", "", .) %>% 
  str_extract("\\s+[0-9A-Z,\\s]+\\s*$") %>% 
  trimws("both") %>% 
  gsub(", ,", "", .)

# Criando o data frame --------------------------------------------

df <- data.frame(id, etnia, codigo)

# openxlsx::write.xlsx(df, "RACA_COR.xlsx")