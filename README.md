# Laboratório das Eleições ONG Elas no Poder
Projeto voluntário para a **[ONG Elas no Poder](https://elasnopoder.org/)**


Este projeto realiza o tratamento e análise dos dados das eleições de 2022 e 2024, focando em fornecer insights e análises sobre candidatas e resultados eleitorais. 
Os dados são obtidos do Tribunal Superior Eleitoral (TSE) através do link:

- [Resultados - Portal de Dados Abertos do TSE](https://dadosabertos.tse.jus.br/dataset/?groups=resultados): `consulta_cand_2022_BRASIL.csv` e `consulta_cand_2024_BRASIL.csv`
- [Candidatos – SIG-Eleição / Conjuntos de Dados](https://sig.tse.jus.br/ords/dwapr/r/seai/sig-eleicao-arquivo/conjuntos-de-dados?p10_nm_modulo=candidatura): `candidatos2024.csv` 

**Nota:** O arquivo `consulta_cand_2024_BRASIL.csv` não está incluído no repositório devido ao seu tamanho (mais de 100 MB), mas pode ser baixado diretamente pelo link acima.

---

## Scripts R e Dashboard Power Bi

| Script | Função principal | Telas Power BI | Arquivo(s) gerados |
|--------|-----------------|----------------------------|--------------------|
| **`tratamento_dados_eleicoes.R`** | Consolida candidaturas 2022 + 2024, trata variáveis de gênero, cor/raça, cargo, partido, escolaridade e estado civil | **Tela 1 – PANORAMA** (distribuição de gênero, raça, cargos, etc.)<br>**Tela 3 – CANDIDATOS(AS)** (lista nome de urna, partido, cargo, município, situação) | `cand_geral.xlsx` |
| **`tratamento_dados_candidatos.R`** | Trata arquivo `candidatos2024.csv`, padroniza campos identitários e classifica situação eleitoral | **Tela 2 – PERFIL SOCIAL** (faixa etária, identidade de gênero, orientação sexual, etnia indígena) | `cand_tela2.xlsx` |
| **`tratamento_dados_eleitorado.R`** | Baixa o **perfil do eleitorado 2024** via `electionsBR`, trata variáveis de gênero, raça, escolaridade e faixa etária | **Tela 4 – ELEITORADO** (piramide etária, gênero, cor/raça, escolaridade, totais) | `perfil_eleitorado_2024.parquet` |

Os dados são alimentados em tempo real para o **Power BI**, permitindo análises detalhadas e dinâmicas sobre as eleições. 
Você pode acessar o dashboard completo [aqui](https://app.powerbi.com/view?r=eyJrIjoiNGE2MmY2Y2YtYzEzYy00ZjUwLWFjODYtZGI2ODNlZThiZmNiIiwidCI6IjVjYTI0MTc0LWYxMzgtNGZlMS1iODY2LWFjZWFlOTRiZjk5MiJ9).

![image](https://github.com/user-attachments/assets/b9862e3b-16a5-46c8-9874-495962a55384)

### Possibilidades de Análise

1. **Panorama das Candidaturas** – Distribuição de gênero, cor/raça, cargos, estado civil, escolaridade e partido entre todas as candidaturas válidas nas eleições de 2022 e 2024 (Tela 1).  
2. **Perfil Social de Candidatos(as)** – Faixa etária, identidade de gênero, orientação sexual e etnia indígena das candidaturas, com filtros por UF, partido, cargo, entre outros (Tela 2). 
3. **Detalhe por Candidata(o)** – Consulta nominal (nome de urna) com partido, cargo, município e situação eleitoral (eleita/o, 2º turno, não eleita/o) (Tela 3).
4. **Resultados Eleitorais** – Comparação de desempenho (eleita/o × não eleita/o) por tipo de eleição, turno e região/UF; inclui análise de 2º turno.  
5. **Eleitorado 2024** – Pirâmide etária e cortes de gênero, cor/raça e escolaridade do corpo eleitoral, com filtros por região, UF, município e condição quilombola (Tela 4).

---

## Instalação e Uso

### Requisitos:

- R e RStudio 
- Pacotes: `readr`, `dplyr`, `stringr`, `writexl`, `electionsBR`, `arrow`

### Passos:

1. Clone este repositório:

   ```bash
   git clone https://github.com/zaradesouza/tratamento-eleicoes.git
   cd tratamento-eleicoes-2022-2024
   ```

2. Baixe os dados dos links fornecidos e salve como `consulta_cand_2022_BRASIL.csv` e `consulta_cand_2024_BRASIL.csv` na pasta do projeto.
3. Instale os pacotes no R: install.packages(c("readr","dplyr","stringr","writexl","electionsBR","arrow")).
5. Execute os scripts:
   source("tratamento_dados_candidatos.R")      # gera cand_tela2.xlsx
   source("tratamento_dados_eleicoes.R")        # gera cand_geral.xlsx
   source("tratamento_dados_eleitorado.R")      # gera perfil_eleitorado_2024.parquet

---

## Contato

Tem dúvidas, achou um bug ou gostaria de sugerir melhorias? 
Me manda um e-mail: [**zara@estudante.ufscar.br**](mailto:zara@estudante.ufscar.br)
