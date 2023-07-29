-- Albuns escutados

SELECT 
	COUNT(1) 
FROM dw.dim_album 
where album_type = 'album';

-- Albuns mais populares

SELECT
	name as album,
	popularity as popularidade
FROM dw.dim_album
WHERE album_type = 'album'
ORDER BY popularidade DESC
LIMIT 5;

-- Albuns mais escutados por quantidade

select
	SUM(quantidade) as quantidade,
	da.name as artista,
	da.popularity
FROM 
dw.fato f
join dw.dim_album da on f.sk_album = da.sk_album
group by f.sk_album, da.name, da.popularity
order by sum(quantidade) desc
limit 8;


-- Albuns por ano de lançamento

select 
	count(1) as qtd,
	substring(release_date from 1 for 4) as ano
from dw.dim_album 
where album_type = 'album' 
group by substring(release_date from 1 for 4);

-- Artistas mais escutados por quantidade

select
	SUM(quantidade) as quantidade,
	da.name as artista
FROM 
dw.fato f
join dw.dim_artist da on f.sk_artist = da.sk_artist
group by f.sk_artist, da.name
order by sum(quantidade) desc
limit 10;


-- Artistas mais populares

SELECT 
	name as artista,
	popularity as popularidade
FROM dw.dim_artist
ORDER BY popularity desc
LIMIT 7;


-- Duração média das músicas

SELECT 
	AVG(duration_ms) / 60000
FROM dw.dim_track;


-- Faixas escutadas por artista e popularidade

select
	SUM(quantidade) as quantidade,
	da.name as artista,
	da.followers as seguidores
FROM dw.fato f
join dw.dim_artist da on f.sk_artist = da.sk_artist
group by f.sk_artist, da.name, da.followers
order by sum(quantidade) desc
limit 8;


-- Minutos escutados no total

select 
	(SUM(quantidade * duration_ms) /60000)
from
(
    select
	    f.quantidade,
	    dt.duration_ms
    from dw.fato f
    join dw.dim_track dt on f.sk_track = dt.sk_track
    order by quantidade desc
) as subquery;


-- Média de minutos escutados por dia

select 
	sum(minutos_escutados) / count(minutos_escutados) as media_minutos
from (
	SELECT
		SUM(f.quantidade * (dt.duration_ms / 60000)) AS minutos_escutados
	FROM dw.fato f
	JOIN dw.dim_track dt ON f.sk_track = dt.sk_track
	JOIN dw.dim_data dd ON f.sk_data = dd.sk_data
	GROUP BY dd.data
) as subquery;

-- Média de popularidade dos artistas

SELECT 
	AVG(popularity)
FROM dw.dim_artist;


-- Músicas diferentes por artista


select 
    count(1) as qtd,
    da.name
from 
(
    select distinct
    	sk_track,
    	sk_artist 
    from dw.fato 
    group by sk_artist, sk_track
    order by sk_artist
) as subquery
join dw.dim_artist da on subquery.sk_artist = da.sk_artist 
group by subquery.sk_artist, da.name
order by qtd desc
limit 5;


-- Músicas distintas

SELECT 
	COUNT(sk_track)
FROM dw.dim_track;


-- Músicas distintas por mês
SELECT 
	COUNT(sk_track) as musicasdiferentes,
	month as mês
FROM 
(
    SELECT distinct 
    	sk_track,
    	dd.month
    from dw.fato f
    JOIN dw.dim_data dd on dd.sk_data = f.sk_data 
    GROUP BY dd.month, f.sk_track
) as subquery
GROUP BY month;


-- Músicas escutadas por dia da semana

SELECT
	SUM(f.quantidade) as musicas,
	d.weekday
FROM dw.fato f
JOIN dw.dim_data d ON f.sk_data = d.sk_data
GROUP BY d.weekday
ORDER BY musicas DESC;


-- Músicas escutadas por hora
select
	SUM(f.quantidade) as musicas,
	dh.hora
from dw.fato f
join dw.dim_hora dh ON f.sk_hora = dh.sk_hora
GROUP BY dh.hora;

-- Músicas explicitas
SELECT COUNT(1),
case
	when explicit = true then 'explicito'
	when explicit = false then 'não explicito'
	else 'ND'
end
FROM dw.dim_track
GROUP BY explicit;

-- Popularidade do album por tipo

select 
    avg(popularity) popularidade,
    album_type as tipo
from dw.dim_album 
group by album_type;

-- Total de músicas escutadas
SELECT 
	SUM(quantidade)
FROM dw.fato