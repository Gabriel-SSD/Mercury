# 🌕 Mercury 
![Badge Linguagem](https://img.shields.io/badge/Linguagem-Python-blue)
![Badge Framework](https://img.shields.io/badge/biblioteca-Pandas-yellow)
![Badge DB](https://img.shields.io/badge/DB-PostgreSQL-blue)
![Badge API](https://img.shields.io/badge/API-Spotipy-green)
![Badge Status](https://img.shields.io/badge/Status-Done-G)
### Spotify ETL Job
Projeto desenvolvido para praticar aprendizados do curso **Design e Modelagem de Data Warehouses** da Data Science Academy. Mais informações no [PDF](https://github.com/Gabriel-SSD/Mercury/blob/main/files/mercury.pdf)

## Sobre a ETL:
O script principal que realiza o processo de ETL é o etl.py, ele realiza a extração de dados da fonte, filtra e chama stored procedures que realizam transformações. Todas as procedures estão em scripts, assim como os scripts de criação do BD. Além disso existem scripts adicionais em /aux, que definem configurações de variáveis de ambiente, funções compartilhadas e backup dos dados. Todos os principais scripts registram seus logs em /logs.
### Passo a passo lógico de etl.py
1. Extração de dados em lotes consumindo a API do Spotify, obtendo dados referentes às ultimas músicas escutadas em determinado período, a partir desse retorno são obtidos os ids de: track, album, artista e o timestamp da escuta.
2. A partir dos ids, são filtrados apenas os ids únicos, para reduzir chamadas aos endpoints na etapa 4.
3. Dependendo do volume de dados, é necessário separar em lotes, pois a API possui limitações de ids por chamada.
4. Com os ids únicos, realizam-se consultas nos respectivos endpoints para obter os dados relacionados aos artistas, tracks e album.
5. Os dados iniciais da primeira extração correspondem a tabela fato, as consultas derivadas da etapa anterior correspondem a dimensões, todos os dataframes são gravados na stage para tratamento.
6. Dentro da stage, são executadas stored procedures que tratam os dados, lidam com inconsistências da fonte e padronizam para serem gravados (upsert) dentro do Data Warehouse.
7. Após o processo os dados se encontram limpos, organizados e estruturados no Data Warehouse disponível para utilização no Metabase.
