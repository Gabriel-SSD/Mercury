-- Questions do Metabase para o Dashboard histórico

-- ALBUNS ESCUTADOS

SELECT 
	COUNT(1) 
FROM dw.dim_album 
WHERE album_type = 'album';

-- ALBUNS MAIS POPULARES

SELECT
	name AS album,
	popularity AS popularidade
FROM dw.dim_album
WHERE album_type = 'album'
ORDER BY popularidade DESC
LIMIT 5;

-- ALBUNS MAIS ESCUTADOS POR QUANTIDADE

SELECT
	SUM(quantidade) AS quantidade,
	da."name" AS album,
	da.popularity
FROM 
	dw.fato f
JOIN dw.dim_album da ON f.sk_album = da.sk_album
GROUP BY f.sk_album, da."name", da.popularity
ORDER BY SUM(quantidade) DESC
LIMIT 8;


-- ALBUNS POR ANO DE LANÇAMENTO

SELECT 
	COUNT(1) AS qtd,
	SUBSTRING(release_date FROM 1 FOR 4) AS ano
FROM dw.dim_album 
WHERE album_type = 'album' 
GROUP BY SUBSTRING(release_date FROM 1 FOR 4);

-- ARTISTAS MAIS ESCUTADOS POR QUANTIDADE

SELECT
	SUM(quantidade) AS quantidade,
	da.name AS artista
FROM 
	dw.fato f
JOIN dw.dim_artist da ON f.sk_artist = da.sk_artist
GROUP BY f.sk_artist, da.name
ORDER BY SUM(quantidade) DESC
LIMIT 10;


-- ARTISTAS MAIS POPULARES

SELECT 
	"name" AS artista,
	popularity AS popularidade
FROM dw.dim_artist
ORDER BY popularity DESC
LIMIT 7;


-- DURAÇÃO MÉDIA DAS MÚSICAS

SELECT 
	AVG(duration_ms) / 60000
FROM dw.dim_track;


-- FAIXAS ESCUTADAS POR ARTISTA E SEGUIDORES
SELECT
	SUM(quantidade) AS quantidade,
	da."name" AS artista,
	da.followers AS seguidores
FROM dw.fato f
JOIN dw.dim_artist da ON f.sk_artist = da.sk_artist
GROUP BY f.sk_artist, da."name", da.followers
ORDER BY SUM(quantidade) DESC
LIMIT 8;



-- MINUTOS ESCUTADOS NO TOTAL

SELECT 
	(SUM(quantidade * duration_ms) / 60000)
FROM
(
    SELECT
	    f.quantidade,
	    dt.duration_ms
    FROM dw.fato f
    JOIN dw.dim_track dt ON f.sk_track = dt.sk_track
    ORDER BY quantidade DESC
) AS subquery;


-- MÉDIA DE MINUTOS ESCUTADOS POR DIA

SELECT 
	SUM(minutos_escutados) / COUNT(minutos_escutados) AS media_minutos
FROM (
	SELECT
		SUM(f.quantidade * (dt.duration_ms / 60000)) AS minutos_escutados
	FROM dw.fato f
	JOIN dw.dim_track dt ON f.sk_track = dt.sk_track
	JOIN dw.dim_data dd ON f.sk_data = dd.sk_data
	GROUP BY dd.data
) AS subquery;

-- MÉDIA DE POPULARIDADE DOS ARTISTAS

SELECT 
	AVG(popularity)
FROM dw.dim_artist;


-- MÚSICAS DIFERENTES POR ARTISTA

SELECT 
	COUNT(1) AS qtd,
	da."name"
FROM 
(
    SELECT DISTINCT
    	sk_track,
    	sk_artist 
    FROM dw.fato 
    GROUP BY sk_artist, sk_track
    ORDER BY sk_artist
) AS subquery
JOIN dw.dim_artist da ON subquery.sk_artist = da.sk_artist 
GROUP BY subquery.sk_artist, da."name"
ORDER BY qtd DESC
LIMIT 5;


-- MÚSICAS DISTINTAS

SELECT 
	COUNT(sk_track)
FROM dw.dim_track;


-- MÚSICAS DISTINTAS POR MÊS

SELECT 
	COUNT(sk_track) AS musicasdiferentes,
	MONTH AS mês
FROM 
(
    SELECT DISTINCT 
    	sk_track,
    	dd.month
    FROM dw.fato f
    JOIN dw.dim_data dd ON dd.sk_data = f.sk_data 
    GROUP BY dd.month, f.sk_track
) AS subquery
GROUP BY MONTH;


-- MÚSICAS ESCUTADAS POR DIA DA SEMANA

SELECT
	SUM(f.quantidade) AS musicas,
	d.weekday
FROM dw.fato f
JOIN dw.dim_data d ON f.sk_data = d.sk_data
GROUP BY d.weekday
ORDER BY musicas DESC;


-- MÚSICAS ESCUTADAS POR HORA

SELECT
	SUM(f.quantidade) AS musicas,
	dh.hora
FROM dw.fato f
JOIN dw.dim_hora dh ON f.sk_hora = dh.sk_hora
GROUP BY dh.hora;

-- MÚSICAS EXPLICITAS

SELECT COUNT(1),
CASE
	WHEN explicit = TRUE THEN 'explicito'
	WHEN explicit = FALSE THEN 'não explicito'
	ELSE 'ND'
END
FROM dw.dim_track
GROUP BY explicit;

-- POPULARIDADE DO ALBUM POR TIPO

SELECT 
	AVG(popularity) AS popularidade,
	album_type AS tipo
FROM dw.dim_album 
GROUP BY album_type;

-- TOTAL DE MÚSICAS ESCUTADAS

SELECT 
	SUM(quantidade)
FROM dw.fato;
