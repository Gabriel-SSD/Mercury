CREATE OR REPLACE PROCEDURE dw.upsert_dims()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
	-- Upsert dim_artist
	INSERT INTO dw.dim_artist ("name", id, followers, popularity, "type", data_carga)
	SELECT
		src."name",
		src.id,
		src.followers,
		src.popularity,
		src."type",
		to_date(src.data_carga, 'dd/mm/yyyy')
	FROM
		stage.stg_dim_artist AS src
	ON CONFLICT (id) DO UPDATE
		SET popularity = EXCLUDED.popularity, data_atualizacao = current_date, followers = EXCLUDED.followers
		WHERE dw.dim_artist.popularity <> EXCLUDED.popularity;

	-- Upsert dim_album
	INSERT INTO dw.dim_album ("name", id, album_type, popularity, "type", label, total_tracks, release_date, data_carga, release_year)
	SELECT
		src."name",
		src.id,
		src.album_type,
		src.popularity,
		src."type",
		src.label,
		src.total_tracks,
		case
			when length(src.release_date) = 4 then CONCAT(src.release_date, '-01-01')
			else src.release_date
		end,
		to_date(src.data_carga, 'dd/mm/yyyy'),
		SUBSTRING(src.release_date FROM 1 FOR 4)::INT
	FROM stage.stg_dim_album AS src
	ON CONFLICT (id) DO UPDATE
		SET popularity = EXCLUDED.popularity, data_atualizacao = current_date
		WHERE dw.dim_album.popularity <> EXCLUDED.popularity;

	-- Upsert dim_track
	INSERT INTO dw.dim_track ("name", id, is_local, explicit, duration_ms, popularity, track_number, "type", data_carga)
	SELECT
		src."name",
		src.id,
		src.is_local,
		src.explicit,
		src.duration_ms,
		src.popularity,
		src.track_number,
		src."type",
		to_date(src.data_carga, 'dd/mm/yyyy')
	FROM stage.stg_dim_track AS src
	ON CONFLICT (id) DO UPDATE
		SET popularity = EXCLUDED.popularity, data_atualizacao = current_date
		WHERE dw.dim_track.popularity <> EXCLUDED.popularity;

	-- Update dim_track com track_features
	UPDATE dw.dim_track SET
		acousticness = tf.acousticness,
		danceability = tf.danceability,
		energy = tf.energy,
		instrumentalness = tf.instrumentalness,
		"key" = tf."key",
		liveness = tf.liveness,
		"mode" = tf."mode",
		speechiness = tf.speechiness,
		tempo = tf.tempo,
		time_signature = tf.time_signature,
		valence = tf.valence
	FROM stage.stg_track_features tf
	WHERE dw.dim_track.id = tf.track_id and dw.dim_track.energy is null;

END;
$procedure$
;
