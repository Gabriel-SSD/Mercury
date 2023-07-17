CREATE OR REPLACE PROCEDURE dbo.upsert_dims()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
	-- Upsert dim_artist
	INSERT INTO dbo.dim_artist ("name", id, followers, popularity, "type", data_carga)
	SELECT src."name", src.id, src.followers, src.popularity, src."type", to_date(src.data_carga, 'dd/mm/yyyy')
	FROM stage.stg_dim_artist AS src
	ON CONFLICT (id) DO UPDATE
	SET popularity = EXCLUDED.popularity, data_atualizacao = current_date, followers = EXCLUDED.followers
	WHERE dbo.dim_artist.popularity <> EXCLUDED.popularity;
	
	-- Upsert dim_album
	INSERT INTO dbo.dim_album ("name", id, album_type, popularity, "type", label, total_tracks, release_date, data_carga)
	SELECT src."name", src.id, src.album_type, src.popularity, src."type", src.label, src.total_tracks, src.release_date, to_date(src.data_carga, 'dd/mm/yyyy')
	FROM stage.stg_dim_album AS src
	ON CONFLICT (id) DO UPDATE
	SET popularity = EXCLUDED.popularity, data_atualizacao = current_date
	WHERE dbo.dim_album.popularity <> EXCLUDED.popularity;
	
	-- Upsert dim_track
	INSERT INTO dbo.dim_track ("name", id, is_local, explicit, duration_ms, popularity, track_number, "type", data_carga)
	SELECT src."name", src.id, src.is_local, src.explicit, src.duration_ms, src.popularity, src.track_number, src."type", to_date(src.data_carga, 'dd/mm/yyyy')
	FROM stage.stg_dim_track AS src
	ON CONFLICT (id) DO UPDATE
	SET popularity = EXCLUDED.popularity, data_atualizacao = current_date
	WHERE dbo.dim_track.popularity <> EXCLUDED.popularity;
	
END;
$procedure$
;