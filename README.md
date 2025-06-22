# Laboratório das Eleições ONG Elas no Poder
Projeto voluntário para a **[ONG Elas no Poder](https://elasnopoder.org/)**


Este projeto realiza o tratamento e análise dos dados das eleições de 2022 e 2024, focando em fornecer insights e análises sobre candidatas e resultados eleitorais. Os dados são obtidos do Tribunal Superior Eleitoral (TSE) através dos links:

- [Resultados - Portal de Dados Abertos do TSE](https://dadosabertos.tse.jus.br/dataset/?groups=resultados)

**Nota:** O arquivo `consulta_cand_2024_BRASIL.csv` não está incluído no repositório devido ao seu tamanho (mais de 100 MB), mas pode ser baixado diretamente pelos links acima.

---

## Dashboard Power BI

Os dados são alimentados em tempo real para o **Power BI**, permitindo análises detalhadas e dinâmicas sobre as eleições. 
Você pode acessar o dashboard completo [aqui](https://app.powerbi.com/view?r=eyJrIjoiNGE2MmY2Y2YtYzEzYy00ZjUwLWFjODYtZGI2ODNlZThiZmNiIiwidCI6IjVjYTI0MTc0LWYxMzgtNGZlMS1iODY2LWFjZWFlOTRiZjk5MiJ9).

![image](https://github.com/user-attachments/assets/b9862e3b-16a5-46c8-9874-495962a55384)



### Possibilidades de Análise:

1. **Distribuição de Candidatos por Partido e Estado**: Visualização detalhada da representatividade de cada partido e estado nas eleições.

2. **Resultados por Tipo de Eleição**: Comparação entre diferentes tipos de eleições (municipal, estadual, federal) e seus resultados.

3. **Perfil dos Candidatos**: Análise demográfica dos candidatos, incluindo gênero, raça, escolaridade e profissão.

4. **Desempenho Eleitoral**: Visualização do desempenho dos candidatos eleitos e não eleitos, incluindo resultados de segundo turno.

---

## Instalação e Uso

### Requisitos:

- R e RStudio 
- Pacotes necessários: `readr`, `dplyr`, `stringr`

### Passos:

1. Clone este repositório:

   ```bash
   git clone https://github.com/zaradesouza/tratamento-eleicoes.git
   cd tratamento-eleicoes
   ```

2. Baixe os dados dos links fornecidos e salve como `consulta_cand_2022_BRASIL.csv` e `consulta_cand_2024_BRASIL.csv` na pasta do projeto.
3. Abra o script `tratamento_dados_eleicoes.R` no RStudio e execute para carregar e analisar os dados.

---

## Contato

Tem dúvidas, achou um bug ou gostaria de sugerir melhorias? 
Me manda um e-mail: [**zara@estudante.ufscar.br**](mailto:zara@estudante.ufscar.br)
