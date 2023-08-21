# Pacotes Importantes ---------------------------------------------------------

library(tidyverse)
library(pdftools)

# Lendo o pdf -----------------------------------------------------------------

pdf <- pdf_text("Regex/cadastro.pdf")
pdf <- str_split_1(pdf, "\\n")
pdf

# Extraindo o CPF -------------------------------------------------------------

x <- pdf[grepl("cpf|CPF",pdf)] # seleciona onde tem cpf
x <- gsub("cpf: |CPF: ", "", x) # remove a palavra cpf
x <- gsub("[^0-9]", "", x) # remove caracteres não numéricos
