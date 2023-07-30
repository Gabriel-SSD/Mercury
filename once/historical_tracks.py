import logging as log
import spotipy
import pandas as pd
import psycopg2 as pg
from sqlalchemy import create_engine, MetaData
from spotipy.oauth2 import SpotifyClientCredentials
from aux.util import *
from os import getenv
from aux.config import load_env
import json


def historical_tracks():
    with open("../history/Streaming_History_Audio_2021-2023_0.json") as file:
        tracklist = json.load(file)

    # Obter uma lista de todos os spotify_track_uri presentes no JSON, excluindo entradas com valor None
    spotify_track_uris = [registro["spotify_track_uri"] for registro in tracklist if registro.get("spotify_track_uri")]

    try:
        sp = spotipy.Spotify(client_credentials_manager=SpotifyClientCredentials())

        tracks = []
        for start in range(0, len(spotify_track_uris), 49):
            end = min(start + 49, len(spotify_track_uris))
            batch_track_uris = spotify_track_uris[start:end]

            # Obter informações de um lote (batch) de faixas
            tracks_raw = sp.tracks(batch_track_uris)
            for track_raw, registro in zip(tracks_raw["tracks"], tracklist[start:end]):
                try:
                    track_id = track_raw["id"]
                    album_id = track_raw["album"]["id"]
                    artist_id = track_raw["artists"][0]["id"]

                    # Obter played_at do JSON
                    played_at = convert_to_datetime(registro["ts"])

                    track_data = {
                        'track_id': track_id,
                        'album_id': album_id,
                        'artist_id': artist_id,
                        'played_at': played_at,
                        'data_carga': get_date(),
                    }
                    tracks.append(track_data)
                except TypeError as te:
                    print(f"TypeError: {te}")
                    # Caso ocorra TypeError (provavelmente devido à track_info retornando None),
                    # continuamos sem adicionar essa faixa e passamos para a próxima
                    continue

        all_tracks_info = pd.DataFrame(tracks)
        return all_tracks_info

    except (spotipy.SpotifyException, spotipy.SpotifyOauthError, Exception) as e:
        log.error(f"Erro durante o processamento da track: {str(e)}")


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
            engine = create_engine('postgresql+psycopg2://', creator=lambda: conn)
            track_list.to_sql('stg_fato', con=engine, if_exists='replace', index=False, schema=metadata.schema)
            artists.to_sql('stg_dim_artist', con=engine, if_exists='replace', index=False, schema=metadata.schema)
            albums.to_sql('stg_dim_album', con=engine, if_exists='replace', index=False, schema=metadata.schema)
            tracks.to_sql('stg_dim_track', con=engine, if_exists='replace', index=False, schema=metadata.schema)
            tracks_f.to_sql('stg_track_features', con=engine, if_exists='replace', index=False, schema=metadata.schema)
            log.info("Carga na stage bem sucedida")
            return True
    except Exception as e:
        log.error("Ocorreu um erro durante a execução da carga: %s", str(e))
        return False


def upsert_dw():
    with pg.connect(host=getenv('HOST'), dbname=getenv('DB'), user=getenv('USER'), password=getenv('PW')) as conn:
        try:
            with conn.cursor() as cursor:
                cursor.execute("CALL dw.upsert_dims()")
                cursor.execute("CALL dw.insert_fato()")
            conn.commit()
            log.info("Procedures executadas com sucesso")
        except pg.Error as e:
            log.error(f"Erro ao executar a procedure: {e}")


def etl_historical():
    # Extrai tracks recentes
    log.info(f"Extracting tracks...")
    all_tracks_fact = historical_tracks()
    unique_tracks = all_tracks_fact['track_id'].unique().tolist()
    unique_albums = all_tracks_fact['album_id'].unique().tolist()
    unique_artists = all_tracks_fact['artist_id'].unique().tolist()
    log.info(f"Distinct Artists: {len(unique_artists)} - Albums: {len(unique_albums)} - Tracks: {len(unique_tracks)}")

    # Durante o reprocessamento histórico, todos as dimensões precisarão ser em lotes
    album_batch = [unique_albums[i:i + 20] for i in range(0, len(unique_albums), 20)]
    tracks_batch = [unique_tracks[i:i + 50] for i in range(0, len(unique_tracks), 50)]
    artists_batch = [unique_artists[i:i + 50] for i in range(0, len(unique_artists), 50)]

    log.info("Getting artists data...")
    artists_data = pd.concat([get_artists_data(artist) for artist in artists_batch])
    log.info("Getting albums data...")
    albums_data = pd.concat([get_albums_data(album) for album in album_batch])
    log.info("Getting tracks data...")
    tracks_data = pd.concat([get_tracks_data(track) for track in tracks_batch])

    tracks_features_data = pd.concat([get_tracks_features(ftrack) for ftrack in tracks_batch])

    # Após extraídos os dados, são armazenados em uma stage
    # recents_tracks corresponderá a fato, com a data em que foi escutada a música, permitindo tracks repetidas
    log.info("Loading stage...")
    flag_to_upsert = load_stage(all_tracks_fact, artists_data, albums_data, tracks_data, tracks_features_data)
    if flag_to_upsert:
        log.info("Updating dw...")
        upsert_dw()


if __name__ == '__main__':
    # Mesma estrutura da função principal, mas com algumas modificações para processar um maior volume de dados
    load_env()
    log.basicConfig(
        level=log.INFO,
        format='%(asctime)s.%(msecs)03d - %(levelname)s: %(message)s',
        datefmt='%Y-%m-%d %H:%M:%S',
        handlers=[log.FileHandler('../logs/etl_historical.log')]
    )
    etl_historical()
