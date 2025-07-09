###############################################################################
#Laboratório das Eleições ONG Elas no Poder
# PERFIL DO ELEITORADO – ELEIÇÃO 2024
# Fonte: pacote electionsBR
###############################################################################

# ---- Carregar Pacotes ----
library(electionsBR)
library(dplyr)     
library(stringr)
library(arrow)

# ---- Obter Dados ----
perfil_2024 <-  electionsBR:::voter_profile(
  year     = 2024,           # ano
  encoding = "windows-1252", # codificação original indicada no help
  temp     = TRUE            # guarda o .zip 
)

# Estrutura 
str(perfil_2024)

# Padronizar strings
primeira_maiuscula <- function(x) {
  str_to_title(str_trim(str_to_lower(x)), locale = "pt_BR")
}

perfil_2024 <- perfil_2024 %>% 
  mutate(
    across(
      c(DS_IDENTIDADE_GENERO, DS_QUILOMBOLA, DS_RACA_COR, DS_GRAU_ESCOLARIDADE,
        DS_ESTADO_CIVIL, DS_GENERO, NM_MUNICIPIO),
      ~ primeira_maiuscula(.)
    )
  )

# ---- Salvar em Parquet ----

# Caminho de destino
out_parquet <- "perfil_eleitorado_2024.parquet"

# Salvar
write_parquet(perfil_2024, out_parquet, compression = "snappy")


