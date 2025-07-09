###############################################################################
#Laboratório das Eleições ONG Elas no Poder
#Tratamento dos dados das eleições de 2022 e 2024
#Candidaturas
###############################################################################

# ---- Carregar Pacotes ----
library(readr)
library(dplyr)
library(stringr)

# ---- Carregar Arquivos ----
cand_2024 <- read_delim(
  "caminho_do_seu_arquivo_csv",
  delim = ";",
  locale = locale(encoding = "ISO-8859-1")
)

cand_2022 <- read_delim(
  "caminho_do_seu_arquivo_csv",
  delim = ";",
  locale = locale(encoding = "ISO-8859-1")
)

# ---- Ler Colunas dos arquivos ----
# Listar colunas de cand_2024
colnames(cand_2024)

# Listar colunas de cand_2022
colnames(cand_2022)

# Diferenças entre os dois dataframes
setdiff(colnames(cand_2024), colnames(cand_2022))
setdiff(colnames(cand_2022), colnames(cand_2024))

# Tipos das colunas em cand_2022
str(cand_2022, max.level = 1)

# Tipos das colunas em cand_2024
str(cand_2024, max.level = 1)

# ---- Unir arquivos ----
# 1. Obter colunas comuns
colunas_comuns <- intersect(colnames(cand_2022), colnames(cand_2024))

# 2. Identificar tipos principais de cada coluna
tipos_2022 <- sapply(cand_2022[colunas_comuns], function(x) class(x)[1])
tipos_2024 <- sapply(cand_2024[colunas_comuns], function(x) class(x)[1])

# 3. Selecionar colunas com tipos diferentes
colunas_diferentes <- names(tipos_2022)[tipos_2022 != tipos_2024]

# 4. Converter essas colunas para character em ambos os dataframes
for (col in colunas_diferentes) {
  cand_2022[[col]] <- as.character(cand_2022[[col]])
  cand_2024[[col]] <- as.character(cand_2024[[col]])
}

# 5. Selecionar apenas colunas comuns
cand_2022_comum <- cand_2022[, colunas_comuns]
cand_2024_comum <- cand_2024[, colunas_comuns]

# 6. Unir os dataframes
cand_geral <- dplyr::bind_rows(cand_2022_comum, cand_2024_comum)

cat(colnames(cand_geral), sep = "\n")

# ---- Transformação dos dados ----

# Ver valores únicos de Situação de totalização
valores_unicos <- unique(cand_geral$`Situação de totalização`)
print(valores_unicos)


# Transformar valores de "Eleito" em "ELEITO" 
cand_geral$`Situação de totalização` <- ifelse(
  cand_geral$`Situação de totalização` %in% 
    c("Eleito por média", "Eleito por QP", "Eleito"),
  "ELEITO",
  cand_geral$`Situação de totalização`
)

# Conferir valores únicos 
unique(cand_geral$`Situação de totalização`)      
table(cand_geral$`Situação de totalização`)       # contagem de cada valor

cand_geral$`Situação de totalização` <- ifelse(
  cand_geral$`Situação de totalização` == "ELEITO",
  "Eleito",
  cand_geral$`Situação de totalização`
)

unique(cand_geral$`Situação de totalização`)      

# Padronizar valores 
cand_geral <- cand_geral %>% 
  mutate(
    Município = str_to_title(Município, locale = "pt"), 
    Região    = str_to_title(Região   , locale = "pt") 
  )

# Transformar turnos
cand_geral <- cand_geral %>%
  mutate(
    Turno = case_when(
      Turno == 1 ~ "1º Turno",
      Turno == 2 ~ "2º Turno",
      TRUE ~ as.character(Turno)
    )
  )

valores_unicos <- unique(cand_geral$`Turno`)
print(valores_unicos)

valores_unicos <- unique(cand_geral$`Etnia indígena`)
print(valores_unicos)


# 1. Filtra só 2024, mantém valores distintos e ordena
etnias_2024 <- cand_geral %>%
  filter(`Ano de eleição` == 2024) %>%          # apenas 2024
  distinct(`Etnia indígena`) %>%                # valores únicos
  arrange(`Etnia indígena`) %>%                 # ordena alfabeticamente
  pull()                                        # vira vetor simples

# 2. Copia direto para a Área de Transferência (Windows) ------------
writeClipboard(etnias_2024)     

# ---- Salvar ----
writexl::write_xlsx(cand_geral, "cand_tela2.xlsx")
