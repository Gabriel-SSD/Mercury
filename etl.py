import logging as log
from sys import argv
import spotipy
import pandas as pd
import psycopg2 as pg
from sqlalchemy import create_engine, MetaData
from spotipy.oauth2 import SpotifyClientCredentials
from spotipy.oauth2 import SpotifyOAuth
from util import *
from os import getenv
from config import load_env


def get_historical_tracks_features():
    """
    Função para realizar o reprocessamento histórico, obtendo todos os ids existentes na dim_track, e utiliza esses ids
    na chamada a API, retornando um DataFrame com as análises associadas a um track_id, e esse DataFrame é gravado em
    uma tablea no stage.
    """
    metadata = MetaData(schema="stage")
    with pg.connect(host='localhost', dbname='MercuryDW', user='PyCharm', password='pycharm') as conn:
        engine = create_engine('postgresql+psycopg2://', creator=lambda: conn)
        with conn.cursor() as cursor:
            cursor.execute("""SELECT DISTINCT id FROM dbo.dim_track""")
            resultado = cursor.fetchall()
            tids = [item[0] for item in resultado]
    # Limite do endpoint é de 100 ids, portanto separei em lotes de 100
    t_features = [tids[i:i + 100] for i in range(0, len(tids), 100)]
    audiof = pd.concat([get_tracks_features(trackid) for trackid in t_features])
    audiof.to_sql('stg_track_features', con=engine, if_exists='replace', index=False, schema=metadata.schema)


def get_recent_tracks(hours: int):
    """
    Dado uma hora, obtem um DataFrame com as últimas tracks tocadas, com id da track, artista e album
    :param hours: Horas a serem retroagidas para buscar tracks
    :return: DataFrame
    """
    try:
        sp = spotipy.Spotify(auth_manager=SpotifyOAuth(scope='user-read-recently-played'))
        tracks_raw = sp.current_user_recently_played(limit=50, after=timestamp(hours))
        tracks = []
        for track in tracks_raw['items']:
            track_data = {
                'track_id': track['track']['id'],
                'album_id': track['track']['album']['id'],
                'artist_id': track['track']['artists'][0]['id'],
                'played_at': convert_to_datetime(track['played_at']),
                'data_carga': get_date(),
            }
            tracks.append(track_data)
        if len(tracks) == 0:
            log.warning(f"0 tracks entre {to_date(timestamp(hours))} e {to_date(current_timestamp())}")
            exit(0)
        log.info(f"{len(tracks)} tracks entre {to_date(timestamp(hours))} e {to_date(current_timestamp())}")
        return pd.DataFrame(tracks)
    except (spotipy.SpotifyException, spotipy.SpotifyOauthError, Exception) as e:
        log.error(f"Erro durante a extração das tracks: {str(e)}")
        exit(-1)


def get_artists_data(ids):
    """
    Retorna um DataFrame com os dados obtidos através do artist_id
    :param ids: Lista de artist_id
    :return: DataFrame
    """
    try:
        sp = spotipy.Spotify(client_credentials_manager=SpotifyClientCredentials())
        artists_raw = sp.artists(ids)
        artists = []
        for artist in artists_raw['artists']:
            artist_data = {
                "name": artist["name"],
                "popularity": artist["popularity"],
                "type": artist["type"],
                "id": artist["id"],
                "followers": artist["followers"]["total"],
                "data_carga": get_date()
            }
            artists.append(artist_data)
        return pd.DataFrame(artists)
    except(spotipy.SpotifyException, spotipy.SpotifyOauthError, Exception) as e:
        log.error(f"Erro durante o processamento dos artistas: {str(e)}")
        exit(-1)


def get_albums_data(ids):
    """
    Retorna um DataFrame com os dados obtidos através do album_id
    :param ids: Lista de album_id
    :return: DataFrame
    """
    sp = spotipy.Spotify(client_credentials_manager=SpotifyClientCredentials())
    albums_raw = sp.albums(ids)
    albums_data = []
    try:
        for album in albums_raw['albums']:
            data = {
                "name": album["name"],
                "type": album["type"],
                "album_type": album["album_type"],
                "popularity": album["popularity"],
                "release_date": album["release_date"],
                "id": album["id"],
                "label": album["label"],
                "total_tracks": album["total_tracks"],
                "data_carga": get_date()
            }
            albums_data.append(data)
        return pd.DataFrame(albums_data)
    except(spotipy.SpotifyException, spotipy.SpotifyOauthError, Exception) as e:
        log.error(f"Erro durante o processamento dos albums: {str(e)}")
        exit(-1)


def get_tracks_data(ids):
    """
    Retorna um DataFrame com os dados obtidos através do track_id
    :param ids: Lista de track_id
    :return: DataFrame
    """
    try:
        sp = spotipy.Spotify(client_credentials_manager=SpotifyClientCredentials())
        tracks_raw = sp.tracks(ids)
        tracks_data = []
        for track in tracks_raw["tracks"]:
            data = {
                "name": track["name"],
                "id": track["id"],
                "is_local": track["is_local"],
                "explicit": track["explicit"],
                "duration_ms": track["duration_ms"],
                "popularity": track["popularity"],
                "track_number": track["track_number"],
                "type": track["type"],
                "data_carga": get_date()
            }
            tracks_data.append(data)
        return pd.DataFrame(tracks_data)
    except(spotipy.SpotifyException, spotipy.SpotifyOauthError, Exception) as e:
        log.error(f"Erro durante o processamento das tracks: {str(e)}")
        exit(-1)


def get_tracks_features(ids):
    """
    Dado uma lista de tracks ids, retorna uma lista de informações acústicas em relação a track
    :param ids: Lista de track ids
    :return: List
    """
    try:
        sp = spotipy.Spotify(client_credentials_manager=SpotifyClientCredentials())
        features = sp.audio_features(ids)
        features_data = []
        for track in features:
            audio = {
                "track_id": track["id"],
                "acousticness": track["acousticness"],
                "danceability": track["danceability"],
                "energy": track["energy"],
                "instrumentalness": track["instrumentalness"],
                "key": track["key"],
                "liveness": track["liveness"],
                "mode": track["mode"],
                "speechiness": track["speechiness"],
                "tempo": track["tempo"],
                "time_signature": track["time_signature"],
                "valence": track["valence"]
            }
            features_data.append(audio)
        return pd.DataFrame(features_data)
    except(spotipy.SpotifyException, spotipy.SpotifyOauthError, Exception) as e:
        log.error(f"Erro durante o processamento das features: {str(e)}")
        exit(-1)


def load_stage(track_list, artists, albums, tracks, tracks_f):
    """
    Recebe DataFrames como parâmetos e faz uma carga na stage do DW
    :param track_list: DataFrame com tracks escutadas recentemente para compor a fato
    :param artists: DataFrame com artistas e suas informações relacionadas
    :param albums: DataFrame com albums e suas informações relacionadas
    :param tracks: DataFrame com tracks e suas informações relacionadas
    :param tracks_f: DataFrame com tracks e suas análises relacionadas
    :return: None
    """
    metadata = MetaData(schema="stage")
    try:
        with pg.connect(host=getenv('HOST'), dbname=getenv('DB'), user=getenv('USER'), password=getenv('PW')) as conn:
            log.info("Conexão aberta")
            engine = create_engine('postgresql+psycopg2://', creator=lambda: conn)
            track_list.to_sql('stg_fato', con=engine, if_exists='replace', index=False, schema=metadata.schema)
            artists.to_sql('stg_dim_artist', con=engine, if_exists='replace', index=False, schema=metadata.schema)
            albums.to_sql('stg_dim_album', con=engine, if_exists='replace', index=False, schema=metadata.schema)
            tracks.to_sql('stg_dim_track', con=engine, if_exists='replace', index=False, schema=metadata.schema)
            tracks_f.to_sql('stg_track_features', con=engine, if_exists='replace', index=False, schema=metadata.schema)
            log.info("Carga na stage bem sucedida")
            flag = True
    except pg.Error as e:
        log.error("Ocorreu um erro durante a conexão com o banco de dados: %s", str(e))
        flag = False
    except Exception as e:
        log.error("Ocorreu um erro durante a execução a carga: %s", str(e))
        flag = False
    finally:
        log.info("Conexão fechada")
    return flag


def upsert_dbo():
    with pg.connect(host=getenv('HOST'), dbname=getenv('DB'), user=getenv('USER'), password=getenv('PW')) as conn:
        log.info("Conexão aberta")
        try:
            with conn.cursor() as cursor:
                cursor.execute("CALL dbo.upsert_dims()")
                cursor.execute("CALL dbo.insert_fato()")
            conn.commit()
        except pg.Error as e:
            log.error(f"Erro ao executar a procedure: {e}")
        log.info("Conexão fechada")


def etl(hours: int):
    # Extrai tracks recentes
    log.info(f"Extracting tracks...")
    recent_tracks_fact = get_recent_tracks(hours=hours)
    # Separa os ids de track, album e artist, depois filtra por uniques que serão utilizadas para criar dimensões
    unique_tracks = recent_tracks_fact['track_id'].unique().tolist()
    unique_albums = recent_tracks_fact['album_id'].unique().tolist()
    unique_artists = recent_tracks_fact['artist_id'].unique().tolist()
    log.info(f"Distinct Artists: {len(unique_artists)} - Albums: {len(unique_albums)} - Tracks: {len(unique_tracks)}")

    # Limite de albums por endpoint é 20, e no máximo posso extrair 50 albums das tracks, portanto separei em lotes
    album_batch = [unique_albums[i:i + 20] for i in range(0, len(unique_albums), 20)]

    # Extração de dados referentes a cada dimensão, utilizando o endpoint específico
    log.info("Calling get_artist_data...")
    artists_data = get_artists_data(unique_artists)
    log.info("Calling get_album_data...")
    albums_data = pd.concat([get_albums_data(album) for album in album_batch])
    log.info("Calling get_track_data...")
    tracks_data = get_tracks_data(unique_tracks)
    tracks_features_data = get_tracks_features(unique_tracks)

    # Após extraídos os dados, são armazenados em uma stage
    # recents_tracks corresponderá a fato, com a data em que foi escutada a música, permitindo tracks repetidas
    log.info("Loading to database...")
    # flag_to_upsert = load_stage(recent_tracks_fact, artists_data, albums_data, tracks_data, tracks_features_data)

    # Chamada de procedures no banco para fazer upserts no DW, caso a stage tenha sido atualizada
    # if flag_to_upsert:
    #     log.info("Updating dbo...")
    #     upsert_dbo()


if __name__ == '__main__':
    load_env()
    log.basicConfig(
        level=log.INFO,
        format='%(asctime)s.%(msecs)03d - %(levelname)s: %(message)s',
        datefmt='%Y-%m-%d %H:%M:%S',
        handlers=[log.FileHandler('etl_logs.log')]
    )
    backward_hours = int(argv[1]) if len(argv) > 1 else 12
    etl(backward_hours)
