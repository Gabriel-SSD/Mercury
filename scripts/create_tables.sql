--DROP TABLE dbo.dim_artist;

CREATE TABLE dw.dim_artist (
	sk_artist SERIAL not NULL,
	id text NULL,
	"name" text NULL,
	"type" text NULL,
	popularity int2 NULL,
	followers int4 NULL,
	data_carga date NULL,
	data_atualizacao date NULL,
	CONSTRAINT dim_artist_sk PRIMARY KEY (sk_artist),
	CONSTRAINT dim_artist_un UNIQUE (id)
);


--DROP TABLE dbo.dim_album;

CREATE TABLE dw.dim_album (
	sk_album SERIAL not NULL,
	id text NULL,
	"name" text NULL,
	"type" text NULL,
	popularity int2 NULL,
	album_type text NULL,
	release_date text NULL,
	"label" text NULL,
	total_tracks int2 NULL,
	data_carga date NULL,
	data_atualizacao date NULL,
	CONSTRAINT dim_album_sk PRIMARY KEY (sk_album),
	CONSTRAINT dim_album_un UNIQUE (id)
);



--DROP TABLE dbo.dim_track;

CREATE TABLE dbo.dim_track (
	sk_track BIGSERIAL NOT NULL,
	id text NULL,
	"name" text NULL,
	"type" text NULL,
	popularity int4 NULL,
	is_local bool NULL,
	explicit bool NULL,
	duration_ms int4 NULL,
	track_number int4 NULL,
	data_carga date NULL,
	data_atualizacao date NULL,
	acousticness float8 NULL,
	danceability float8 NULL,
	energy float8 NULL,
	instrumentalness float8 NULL,
	"key" int8 NULL,
	liveness float8 NULL,
	"mode" int8 NULL,
	speechiness float8 NULL,
	tempo float8 NULL,
	time_signature int8 NULL,
	valence float8 NULL,
	CONSTRAINT dim_track_sk PRIMARY KEY (sk_track),
	CONSTRAINT dim_track_un UNIQUE (id)
);

-- DROP TABLE dw.fato;

CREATE TABLE dw.fato (
	sk_track int8 NOT NULL,
	sk_album int8 NOT NULL,
	sk_artist int8 NOT NULL,
	sk_data int8 NOT NULL,
	sk_hora int8 NOT NULL,
	quantidade int2 NOT NULL,
	data_carga date NOT NULL,
	CONSTRAINT fato_pk PRIMARY KEY (sk_hora, sk_data, sk_track, sk_album, sk_artist),
	CONSTRAINT fk_fato_dim_album FOREIGN KEY (sk_album) REFERENCES dw.dim_album(sk_album) ON UPDATE CASCADE,
	CONSTRAINT fk_fato_dim_artist FOREIGN KEY (sk_artist) REFERENCES dw.dim_artist(sk_artist) ON UPDATE CASCADE,
	CONSTRAINT fk_fato_dim_data FOREIGN KEY (sk_data) REFERENCES dw.dim_data(sk_data) ON UPDATE CASCADE,
	CONSTRAINT fk_fato_dim_hora FOREIGN KEY (sk_hora) REFERENCES dw.dim_hora(sk_hora) ON UPDATE CASCADE,
	CONSTRAINT fk_fato_dim_track FOREIGN KEY (sk_track) REFERENCES dw.dim_track(sk_track) ON UPDATE CASCADE
);