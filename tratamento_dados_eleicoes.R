###############################################################################
#Laboratório das Eleições ONG Elas no Poder
#Tratamento dos dados das eleições de 2022 e 2024
###############################################################################

# ---- Carregar Pacotes ----
library(readr)
library(dplyr)
library(stringr)


# ---- Carregar Arquivos ----
cand_2024 <- read_delim("caminho_do_seu_arquivo_csv",
                        delim = ";",
                        locale = locale(encoding = "ISO-8859-1"))  

cand_2022 <- read_delim("caminho_do_seu_arquivo_csv",
                        delim = ";",
                        locale = locale(encoding = "ISO-8859-1"))  

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
colunas_selecionadas <- c(
  "DT_GERACAO",
  "ANO_ELEICAO",
  "NM_TIPO_ELEICAO",
  "NR_TURNO",
  "DS_ELEICAO",
  "DT_ELEICAO",
  "TP_ABRANGENCIA",
  "SG_UF",
  "NM_UE",
  "DS_CARGO",
  "NR_CANDIDATO",
  "NM_CANDIDATO",
  "NM_URNA_CANDIDATO",
  "NM_SOCIAL_CANDIDATO",
  "NR_CPF_CANDIDATO",
  "DS_SITUACAO_CANDIDATURA",
  "TP_AGREMIACAO",
  "NR_PARTIDO",
  "SG_PARTIDO",
  "NM_PARTIDO",
  "NM_FEDERACAO",
  "SG_FEDERACAO",
  "DS_COMPOSICAO_FEDERACAO",
  "NM_COLIGACAO",
  "DS_COMPOSICAO_COLIGACAO",
  "SG_UF_NASCIMENTO",
  "DT_NASCIMENTO",
  "NR_TITULO_ELEITORAL_CANDIDATO",
  "DS_GENERO",
  "DS_GRAU_INSTRUCAO",
  "DS_ESTADO_CIVIL",
  "DS_COR_RACA",
  "DS_OCUPACAO",
  "DS_SIT_TOT_TURNO"
)

# Filtrar apenas essas colunas
cand_geral <- cand_geral[, colunas_selecionadas]

# Valores únicos DS_SIT_TOT_TURNO
unique(cand_geral$DS_SIT_TOT_TURNO)


# Transformar valores de Eleito

cand_geral$RESULTADO <- ifelse(
  cand_geral$DS_SIT_TOT_TURNO %in% c("ELEITO POR MÉDIA", "ELEITO POR QP", "ELEITO"),
  "ELEITO",
  cand_geral$DS_SIT_TOT_TURNO
)
unique(cand_geral$DS_SIT_TOT_TURNO)
table(cand_geral$RESULTADO)

# Filtrar casos de 2º turno
segundo_turno <- cand_geral[cand_geral$RESULTADO == "2º TURNO", ]

# Ver valores únicos de ANO_ELEICAO
unique(segundo_turno$ANO_ELEICAO)

# Ver valores únicos de DS_CARGO
unique(segundo_turno$DS_CARGO)

# 1. Filtrar os candidatos com 2º turno
candidatos_2_turno <- cand_geral %>%
  filter(RESULTADO == "2º TURNO") %>%
  select(NM_URNA_CANDIDATO, NR_CPF_CANDIDATO) %>%
  distinct()

# 2. Ver se esses candidatos aparecem com outro resultado
avaliacao_final <- cand_geral %>%
  semi_join(candidatos_2_turno, by = c("NM_URNA_CANDIDATO", "NR_CPF_CANDIDATO")) %>%
  select(NM_URNA_CANDIDATO, NR_CPF_CANDIDATO, RESULTADO) %>%
  distinct()

# 3. Ver a lista de combinações únicas nome + cpf + resultado
avaliacao_final %>%
  arrange(NM_URNA_CANDIDATO, RESULTADO)

avaliacao_final %>%
  filter(RESULTADO == "ELEITO")

avaliacao_final %>%
  filter(RESULTADO == "NÃO ELEITO")

# Adicionar coluna REGIAO com base em SG_UF
cand_geral <- cand_geral %>%
  mutate(
    REGIAO = case_when(
      SG_UF %in% c("DF", "GO", "MT", "MS") ~ "Centro-Oeste",
      SG_UF %in% c("AC", "AP", "AM", "PA", "RO", "RR", "TO") ~ "Norte",
      SG_UF %in% c("AL", "BA", "CE", "MA", "PB", "PE", "PI", "RN", "SE") ~ "Nordeste",
      SG_UF %in% c("ES", "MG", "RJ", "SP") ~ "Sudeste",
      SG_UF %in% c("PR", "RS", "SC") ~ "Sul",
      TRUE ~ "Indefinido"
    )
  )

# Transformar turnos
cand_geral <- cand_geral %>%
  mutate(
    NR_TURNO = case_when(
      NR_TURNO == 1 ~ "1º Turno",
      NR_TURNO == 2 ~ "2º Turno",
      TRUE ~ as.character(NR_TURNO)
    )
  )

# Padronizar maiúsculas
cand_geral <- cand_geral %>%
  mutate(
    TP_ABRANGENCIA = str_to_title(TP_ABRANGENCIA),
    NM_UE = str_to_title(NM_UE),
    DS_CARGO = str_to_title(DS_CARGO),
    DS_SITUACAO_CANDIDATURA = str_to_title(DS_SITUACAO_CANDIDATURA),
    TP_AGREMIACAO = str_to_title(TP_AGREMIACAO),
    DS_GENERO = str_to_title(DS_GENERO),
    DS_GRAU_INSTRUCAO = str_to_title(DS_GRAU_INSTRUCAO),
    DS_COR_RACA = str_to_title(DS_COR_RACA),
    RESULTADO = str_to_title(RESULTADO)
  )

# Padronizar estado civil
cand_geral <- cand_geral %>%
  mutate(
    DS_ESTADO_CIVIL = str_to_sentence(str_to_lower(DS_ESTADO_CIVIL))
  )

# Padronizar ocupação
cand_geral <- cand_geral %>%
  mutate(
    DS_OCUPACAO = str_to_sentence(str_to_lower(DS_OCUPACAO))
  )


# Coluna candidatura
unique(cand_geral$DS_SITUACAO_CANDIDATURA)
unique(cand_geral$DS_GENERO)
unique(cand_geral$DS_CARGO)


# Validação com resultado
cand_geral %>%
  filter(DS_SITUACAO_CANDIDATURA %in% c("#Ne")) %>%
  pull(RESULTADO) %>%
  unique()

cand_geral %>%
  filter(DS_SITUACAO_CANDIDATURA %in% c("Inapto", "#Ne")) %>%
  count(RESULTADO)

cand_geral %>%
  filter(DS_CARGO %in% c("Suplente")) %>%
  pull(RESULTADO) %>%
  unique()

cand_geral %>%
  filter(DS_CARGO %in% c("1º Suplente", "2º Suplente")) %>%
  count(DS_CARGO, RESULTADO)

cand_geral %>%
  filter(
    DS_CARGO %in% c("1º Suplente", "2º Suplente"),
    RESULTADO == "Eleito"
  ) %>%
  distinct(DS_CARGO, DS_SITUACAO_CANDIDATURA)


prefeitos_sp <- cand_geral %>%
  filter(
    DS_CARGO == "Prefeito",
    str_to_lower(NM_UE) == "são paulo"
  )

prefeitos_sp %>%
  distinct(ANO_ELEICAO, NM_URNA_CANDIDATO, NR_CPF_CANDIDATO, RESULTADO)



# ---- Salvar ----
writexl::write_xlsx(cand_geral, "cand_geral.xlsx")


