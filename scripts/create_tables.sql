-- DROP ROLE "MercuryDBA";

CREATE ROLE "MercuryDBA" WITH
	SUPERUSER
	CREATEDB
	CREATEROLE
	INHERIT
	LOGIN
	REPLICATION
	BYPASSRLS
	CONNECTION LIMIT -1;

-- DROP ROLE "Metabase";

CREATE ROLE "Metabase" WITH
	NOSUPERUSER
	NOCREATEDB
	NOCREATEROLE
	NOINHERIT
	LOGIN
	NOREPLICATION
	NOBYPASSRLS
	CONNECTION LIMIT -1;

-- DROP ROLE "PyCharm";

CREATE ROLE "PyCharm" WITH
	NOSUPERUSER
	NOCREATEDB
	NOCREATEROLE
	NOINHERIT
	LOGIN
	NOREPLICATION
	NOBYPASSRLS
	CONNECTION LIMIT -1;

COMMENT ON ROLE "PyCharm" IS 'Usuário para acessar via PyCharm';
-- DROP SCHEMA dw;

CREATE SCHEMA dw AUTHORIZATION "MercuryDBA";

-- Permissions

GRANT ALL ON SCHEMA dw TO "MercuryDBA";
GRANT USAGE ON SCHEMA dw TO "PyCharm";
GRANT USAGE ON SCHEMA dw TO "Metabase";

-- DROP TABLE dw.dim_data;

CREATE TABLE dw.dim_data (
	sk_data int4 NOT NULL,
	"data" date NULL,
	"year" int2 NULL,
	"month" int2 NULL,
	"day" int2 NULL,
	weekday text NULL,
	workday bool NULL,
	holiday bool NULL,
	holiday_name text NULL,
	CONSTRAINT dim_data_pkey PRIMARY KEY (sk_data)
);

-- Permissions

ALTER TABLE dw.dim_data OWNER TO "MercuryDBA";
GRANT ALL ON TABLE dw.dim_data TO "MercuryDBA";
GRANT INSERT, REFERENCES, SELECT, UPDATE ON TABLE dw.dim_data TO "PyCharm";
GRANT SELECT ON TABLE dw.dim_data TO "Metabase";

-- DROP TABLE dw.dim_hora;

CREATE TABLE dw.dim_hora (
	sk_hora int2 NOT NULL,
	hora int2 NULL,
	periodo text NULL,
	CONSTRAINT pk_hora PRIMARY KEY (sk_hora)
);

-- Permissions

ALTER TABLE dw.dim_hora OWNER TO "MercuryDBA";
GRANT ALL ON TABLE dw.dim_hora TO "MercuryDBA";
GRANT INSERT, REFERENCES, SELECT, UPDATE ON TABLE dw.dim_hora TO "PyCharm";
GRANT SELECT ON TABLE dw.dim_hora TO "Metabase";

-- DROP TABLE dw.dim_artist;

CREATE TABLE dw.dim_artist (
	sk_artist serial4 NOT NULL,
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

-- Permissions

ALTER TABLE dw.dim_artist OWNER TO "MercuryDBA";
GRANT ALL ON TABLE dw.dim_artist TO "MercuryDBA";
GRANT INSERT, REFERENCES, SELECT, UPDATE ON TABLE dw.dim_artist TO "PyCharm";
GRANT SELECT ON TABLE dw.dim_artist TO "Metabase";


--DROP TABLE dbo.dim_album;

CREATE TABLE dw.dim_album (
	sk_album serial4 NOT NULL,
	id text NULL,
	"name" text NULL,
	"type" text NULL,
	popularity int2 NULL,
	album_type text NULL,
	release_date text NULL,
	release_year int2 NULL,
	"label" text NULL,
	total_tracks int2 NULL,
	data_carga date NULL,
	data_atualizacao date NULL,
	CONSTRAINT dim_album_sk PRIMARY KEY (sk_album),
	CONSTRAINT dim_album_un UNIQUE (id)
);

-- Permissions

ALTER TABLE dw.dim_album OWNER TO "MercuryDBA";
GRANT ALL ON TABLE dw.dim_album TO "MercuryDBA";
GRANT INSERT, REFERENCES, SELECT, UPDATE ON TABLE dw.dim_album TO "PyCharm";
GRANT SELECT ON TABLE dw.dim_album TO "Metabase";

-- DROP TABLE dw.dim_track;

CREATE TABLE dw.dim_track (
	sk_track serial4 NOT NULL,
	id text NULL,
	"name" text NULL,
	"type" text NULL,
	popularity int2 NULL,
	is_local bool NULL,
	explicit bool NULL,
	duration_ms int4 NULL,
	track_number int2 NULL,
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

-- Permissions

ALTER TABLE dw.dim_track OWNER TO "MercuryDBA";
GRANT ALL ON TABLE dw.dim_track TO "MercuryDBA";
GRANT INSERT, REFERENCES, SELECT, UPDATE ON TABLE dw.dim_track TO "PyCharm";
GRANT SELECT ON TABLE dw.dim_track TO "Metabase";

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
