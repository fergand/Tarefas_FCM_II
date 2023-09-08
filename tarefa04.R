# Pacotes Importantes ---------------------------------------------------------

library(tidyverse)
library(pdftools)

# Lendo o pdf -----------------------------------------------------------------

pdf <- pdf_text("Regex/cadastro.pdf")
pdf <- str_split_1(pdf, "\\n")
pdf

# Extraindo o endereço --------------------------------------------------------
address <- pdf[grepl("[Ee]ndere", pdf)]
address <- gsub("Endereço: ", "", address)
(address <- gsub("CEP: \\d+\\-\\d+", "", address))

# separando a rua do endereço -------------------------------------------------
(street <- str_extract(street, "^[^,]+"))

# separando o número ----------------------------------------------------------
(number <- str_extract(address, "\\b\\d+\\b|SN"))

# separando a cidade?planeta --------------------------------------------------
city <- str_extract(address, "\\s*([^,]+)$")
city <- gsub("\\.", "", city)
(city <- trimws(city, "both"))
