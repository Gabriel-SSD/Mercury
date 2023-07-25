**Consultas Básicas:**

1. Qual é o número total de registros na tabela fato?
2. Quais são as dimensões disponíveis no DW?
3. Quantas músicas diferentes temos na tabela de dimensão "Dim Track"?
4. Quais são os cinco artistas mais populares?
5. Quais são os três álbuns mais populares?
6. Quantos registros de escuta temos na tabela fato?
7. Quantos minutos de música foram escutados no total?
8. Qual é o dia da semana com o maior número de escutas?
9. Quantas músicas explícitas temos no DW?
10. Qual é o número médio de escutas por hora?

**Consultas com Agregações:**

11. Quantas escutas ocorreram em cada hora do dia?
12. Qual é a média de popularidade dos artistas por tipo?
13. Quantas escutas ocorreram em cada dia da semana?
14. Qual é a duração média das músicas por tipo?
15. Quantas músicas diferentes foram escutadas em cada mês?
16. Qual é o total de seguidores para cada artista?
17. Quantas músicas foram lançadas por mês?
18. Qual é a popularidade média dos álbuns por tipo?
19. Quantas músicas cada artista tem no DW?
20. Qual é o dia do mês com mais escutas?

**Consultas com Junções:**

21. Quais são os artistas mais populares cujas músicas foram escutadas nos últimos 7 dias?
22. Quais são os álbuns mais populares lançados no último ano?
23. Quais músicas explícitas foram escutadas no mês passado?
24. Quantas músicas diferentes foram escutadas em cada mês do ano?
25. Quais são as músicas mais populares tocadas nas segundas-feiras?
26. Qual é o álbum mais popular lançado por cada artista?
27. Quais são as músicas mais longas e mais curtas em termos de duração?
28. Quais são os artistas com o maior número de seguidores cujas músicas foram escutadas nas últimas 24 horas?
29. Quantos minutos de música foram escutados por cada tipo de artista?
30. Quais são os dias da semana em que mais músicas diferentes foram escutadas?

**Consultas com Subconsultas e CTEs:**

31. Quais são as músicas com uma popularidade maior que a média de popularidade dos artistas?
32. Quais são os artistas com uma popularidade acima da média dos artistas cujas músicas foram escutadas no mês passado?
33. Quantas músicas diferentes têm uma duração menor que a média de duração das músicas explícitas?
34. Quais são os artistas mais populares cujas músicas foram escutadas no mês passado e possuem mais de 100.000 seguidores?
35. Quais são as músicas mais populares tocadas nas segundas-feiras que duram mais de 4 minutos?
36. Quais são os álbuns mais populares lançados por artistas com uma média de popularidade superior a 80?
37. Quais são as músicas com uma duração maior que a média de duração das músicas de cada artista?
38. Quais são os artistas com uma popularidade superior à média dos artistas que têm seguidores acima da média de seguidores dos artistas explícitos?
39. Quais são os álbuns mais populares lançados por artistas que possuem mais de 1.000 seguidores e uma média de popularidade acima de 70?
40. Quais são as músicas com uma popularidade superior à média das músicas que duram mais de 3 minutos?

**Consultas de Junção com Funções de Janela:**

41. Quais são as 5 músicas mais populares de cada mês do ano?
42. Para cada hora do dia, quais são as 3 músicas mais escutadas?
43. Quais são as músicas com a maior duração em cada álbum?
44. Quais são os 5 artistas mais populares em termos de seguidores em cada mês do ano?
45. Para cada dia da semana, quais são as 5 músicas mais escutadas?
46. Quais são os artistas com a maior duração média de música por tipo?
47. Quais são as 3 músicas mais populares em cada período do dia (manhã, tarde, noite)?
48. Quais são os álbuns com a maior duração média de música por tipo?
49. Quais são as músicas com a maior popularidade em cada mês do ano?
50. Quais são os artistas com a maior duração média de música por dia da semana?

**Consultas de Filtragem e Agrupamento:**

51. Quais são as músicas mais populares tocadas nos períodos da manhã de cada dia da semana?
52. Quais são as músicas com a duração mais curta e mais longa escutadas no último mês?
53. Quais são as músicas mais populares tocadas nas tardes de terças-feiras?
54. Quais são as músicas tocadas no último mês que têm uma popularidade maior que 90 e uma duração menor que 2 minutos?
55. Quais são as músicas mais populares tocadas nas noites de sextas-feiras?
56. Quais são as músicas que possuem um índice de dança superior à média de índice de dança das músicas explícitas?
57. Quais são as músicas que foram lançadas no último ano e têm um índice de dança superior a 0,7?
58. Quais são as músicas mais populares tocadas nos feriados?
59. Quais são as músicas explícitas que foram escutadas em um dia de trabalho (workday)?
60. Quais são as músicas tocadas nos feriados que têm uma energia maior que 0,8?

**Consultas com Junções e Funções de Agregação:**

61. Quantos seguidores têm os artistas cujas músicas foram escutadas nas noites de sextas-feiras?
62. Qual é a média de popularidade das músicas de cada álbum lançado no último ano?
63. Quantas

 músicas diferentes foram escutadas em cada mês por tipo de artista?
64. Quantos minutos de música foram escutados em cada hora do dia no último mês?
65. Quantas músicas explícitas foram escutadas nos dias úteis (workdays) do último mês?
66. Qual é o número total de seguidores para cada tipo de artista cujas músicas foram escutadas nos dias úteis (workdays)?
67. Quantos minutos de música foram escutados em cada dia do mês do último ano?
68. Qual é a popularidade média dos artistas cujas músicas foram escutadas nas manhãs de sextas-feiras?
69. Quantas músicas explícitas foram escutadas em cada dia do mês no último ano?
70. Qual é a duração média das músicas escutadas nos feriados?

**Consultas com Funções Matemáticas:**

71. Qual é o total de segundos de música escutados no último mês?
72. Qual é a duração total em minutos das músicas explícitas tocadas nas noites de sextas-feiras?
73. Qual é a média de duração das músicas explícitas escutadas no último mês?
74. Qual é o total de segundos de música escutados nas manhãs de segundas-feiras?
75. Qual é o total de segundos de música escutados em cada período do dia?
76. Qual é o total de minutos de música escutados nas tardes de quintas-feiras?
77. Qual é a média de duração das músicas de cada álbum?
78. Qual é o total de segundos de música escutados em cada hora do dia no último mês?
79. Qual é o total de segundos de música escutados nas noites de sábados?
80. Qual é a média de duração das músicas escutadas nos feriados?

**Consultas com Subconsultas Correlacionadas:**

81. Quais são as músicas que foram lançadas no mesmo ano que o álbum mais recente?
82. Quais são as músicas escutadas na mesma hora do dia que a música mais escutada?
83. Quais são as músicas que têm uma duração igual à música mais longa?
84. Quais são as músicas que têm uma duração maior que a média de duração das músicas escutadas no último mês?
85. Quais são as músicas que têm uma popularidade maior que a média de popularidade das músicas escutadas no último mês?
86. Quais são as músicas que têm uma popularidade igual à música mais popular?
87. Quais são as músicas que foram lançadas no mesmo mês e ano que o álbum mais antigo?
88. Quais são as músicas que foram lançadas no mesmo mês que o álbum mais antigo?
89. Quais são as músicas que têm uma duração menor que a média de duração das músicas tocadas em um dia de trabalho (workday)?
90. Quais são as músicas que têm uma popularidade menor que a média de popularidade das músicas escutadas nas noites de sextas-feiras?

**Consultas com Junções e Funções de Janela com Filtragem:**

91. Quais são as músicas com uma popularidade maior que a média de popularidade das músicas tocadas nas noites de sextas-feiras?
92. Quais são as músicas que foram lançadas no mesmo ano que o álbum mais recente dos artistas cujas músicas foram escutadas nas manhãs de quartas-feiras?
93. Quais são as músicas com uma duração menor que a média de duração das músicas de cada álbum?
94. Quais são as músicas que foram lançadas no mesmo mês e ano que o álbum mais recente dos artistas com mais de 1.000 seguidores?
95. Quais são as músicas com uma popularidade maior que a média de popularidade das músicas de cada artista que têm seguidores acima da média de seguidores dos artistas explícitos?
96. Quais são as músicas com uma duração maior que a média de duração das músicas dos álbuns que têm um tipo de álbum mais popular?
97. Quais são as músicas com uma popularidade maior que a média de popularidade das músicas dos artistas com mais de 500 seguidores?
98. Quais são as músicas com uma duração menor que a média de duração das músicas dos artistas com mais de 100.000 seguidores?
99. Quais são as músicas com uma popularidade maior que a média de popularidade das músicas dos artistas cujas músicas foram escutadas no último mês?
100. Quais são as músicas com uma duração maior que a média de duração das músicas dos álbuns com uma média de popularidade maior que 80?

**Consultas com Funções de Data e Hora:**

101. Quantos dias de trabalho (workdays) temos no último mês?
102. Quantos minutos de música foram escutados no último trimestre?
103. Qual é o primeiro dia do mês com o maior número de escutas?
104. Quais são as músicas que foram lançadas no último trimestre?
105. Quais são as músicas tocadas no último dia do mês?
106. Qual é o último dia do mês com o maior número de escutas?
107. Quantos segundos de música foram escutados no último dia do mês?
108. Qual é o primeiro dia do ano com o maior número de escutas?
109. Quais são as músicas que foram lançadas no último dia do mês?
110. Quantos minutos de música foram escutados em cada semana do último mês?

**Consultas com Junções, Funções de Janela e Funções de Data e Hora:**

111. Qual é o total de minutos de música escutados em cada semana do último trimestre?
112. Quantas músicas foram lançadas em cada mês do último trimestre?
113. Quais são as músicas mais populares tocadas na primeira semana do último trimestre?
114. Qual é o total de segundos de música escutados no último trimestre?
115. Quais são as músicas mais populares tocadas no último dia do mês?
116. Qual é o primeiro dia do trimestre com o maior número de escutas?
117. Quais são as músicas que foram lançadas no primeiro dia do trimestre?
118. Qual é o último dia do trimestre com o maior número de escutas?
119. Quais são as músicas que foram lançadas no último dia do trimestre?
120. Quantas músicas foram lançadas em cada semana do último trimestre?

**Consultas com

 Funções de Agregação Condicionais (CASE WHEN):**

121. Quantos minutos de música foram escutados nos dias úteis (workdays) do último mês?
122. Qual é o total de segundos de música escutados nas tardes dos dias úteis (workdays)?
123. Quantos minutos de música foram escutados em cada período do dia no último mês?
124. Qual é o total de segundos de música escutados nas noites dos feriados?
125. Quais são as músicas explícitas com uma duração maior que 3 minutos?
126. Quantos minutos de música foram escutados nas manhãs de segundas-feiras?
127. Quais são as músicas explícitas com uma popularidade maior que 80?
128. Qual é o total de segundos de música escutados nas tardes de quintas-feiras?
129. Quantas músicas explícitas foram escutadas nas noites de sextas-feiras?
130. Quais são as músicas explícitas com uma popularidade maior que 90?

**Consultas com Junções e Funções de Janela com Funções de Agregação Condicionais (CASE WHEN):**

131. Quais são as músicas com uma popularidade maior que 80 e que foram lançadas no último ano?
132. Quantos minutos de música foram escutados em cada hora do dia nos feriados?
133. Quais são as músicas com uma duração maior que a média de duração das músicas explícitas tocadas nas noites de sextas-feiras?
134. Qual é o total de segundos de música escutados em cada período do dia nas noites de sextas-feiras?
135. Quais são as músicas com uma duração maior que a média de duração das músicas tocadas nos dias úteis (workdays)?
136. Quantos minutos de música foram escutados em cada dia do mês no último ano?
137. Quais são as músicas com uma popularidade maior que a média de popularidade das músicas escutadas nas noites de sextas-feiras e que têm uma duração maior que 4 minutos?
138. Qual é o total de segundos de música escutados em cada hora do dia nas tardes de quintas-feiras?
139. Quais são as músicas com uma popularidade maior que a média de popularidade das músicas tocadas nas manhãs de segundas-feiras e que têm uma duração maior que 3 minutos?
140. Quantos minutos de música foram escutados em cada dia do mês no último trimestre?

**Consultas com Junções, Funções de Janela, Funções de Agregação Condicionais (CASE WHEN) e Funções de Data e Hora:**

141. Quais são as músicas mais populares tocadas no último dia do trimestre e que foram lançadas no último mês?
142. Quantos segundos de música foram escutados nas tardes dos feriados do último trimestre?
143. Quais são as músicas com uma popularidade maior que 80 e que foram lançadas no último trimestre?
144. Qual é o total de minutos de música escutados em cada hora do dia nas manhãs de segundas-feiras?
145. Quais são as músicas com uma duração maior que a média de duração das músicas tocadas nas tardes dos feriados?
146. Quantos segundos de música foram escutados nas noites dos feriados do último mês?
147. Quais são as músicas com uma popularidade maior que a média de popularidade das músicas tocadas no último dia do trimestre e que foram lançadas no último ano?
148. Qual é o total de minutos de música escutados em cada período do dia nas manhãs de segundas-feiras?
149. Quais são as músicas com uma duração maior que a média de duração das músicas tocadas no último dia do mês e que têm uma popularidade maior que 90?
150. Quantos segundos de música foram escutados nas tardes dos feriados do último mês?