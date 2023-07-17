--DROP TABLE dbo.dim_artist;

CREATE TABLE dbo.dim_artist (
	sk_artist BIGSERIAL not NULL,
	id text NULL,
	"name" text NULL,
	"type" text NULL,
	popularity int4 NULL,
	followers int4 NULL,
	data_carga date NULL,
	data_atualizacao date NULL,
	CONSTRAINT dim_artist_sk PRIMARY KEY (sk_artist),
	CONSTRAINT dim_artist_un UNIQUE (id)
);


--DROP TABLE dbo.dim_album;

CREATE TABLE dbo.dim_album (
	sk_album BIGSERIAL not NULL,
	id text NULL,
	"name" text NULL,
	"type" text NULL,
	popularity int4 NULL,
	album_type text NULL,
	release_date text NULL,
	"label" text NULL,
	total_tracks int8 NULL,
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

--DROP TABLE dbo.fato;

CREATE TABLE dbo.fato (
	sk_track int8 NOT NULL,
	sk_album int8 NOT NULL,
	sk_artist int8 NOT NULL,
	played_at timestamp(0) NOT NULL,
	data_carga date NULL,
	CONSTRAINT fato_pkey PRIMARY KEY (sk_track, sk_album, sk_artist, played_at),
	CONSTRAINT fk_album FOREIGN KEY (sk_album) REFERENCES dbo.dim_album(sk_album),
	CONSTRAINT fk_artist FOREIGN KEY (sk_artist) REFERENCES dbo.dim_artist(sk_artist),
	CONSTRAINT fk_track FOREIGN KEY (sk_track) REFERENCES dbo.dim_track(sk_track)
);