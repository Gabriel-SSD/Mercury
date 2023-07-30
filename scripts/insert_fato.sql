CREATE OR REPLACE PROCEDURE dw.insert_fato()
 LANGUAGE plpgsql
AS $procedure$
	begin
		INSERT INTO dw.fato (sk_track, sk_album, sk_artist, sk_data, sk_hora, quantidade, data_carga)
SELECT
    dt.sk_track,
    da.sk_album,
    daa.sk_artist,
    ddt.sk_data,
    dh.sk_hora,
    COUNT(*) as qtd,
    to_date(sf.data_carga, 'dd/mm/yyyy')
from stage.stg_fato sf
join dw.dim_track dt ON sf.track_id = dt.id
join dw.dim_album da ON sf.album_id = da.id
join dw.dim_artist daa ON sf.artist_id = daa.id
join dw.dim_hora dh ON extract(hour FROM cast(sf.played_at as timestamp)) = dh.hora
join dw.dim_data ddt ON to_date(sf.played_at, 'yyyy/mm/dd') = ddt."data"
GROUP BY
    dt.sk_track,
    da.sk_album,
    daa.sk_artist,
    ddt.sk_data,
    dh.sk_hora,
    to_date(sf.data_carga, 'dd/mm/yyyy')
ON CONFLICT DO NOTHING;
end;

$procedure$
;
